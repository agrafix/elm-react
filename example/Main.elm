module Main where

import React as R
import React.Component as R

import Effects
import Task

type alias Model =
    { counter : Int
    }

type Action
    = Increment
    | Nop

init : (Model, Effects.Effects Action)
init =
    ({ counter = 0 }, Effects.none)

update : Action -> Model -> (Model, Effects.Effects Action)
update a m =
    case a of
        Increment ->
            ( { m
                  | counter = m.counter + 1
              }
            , Effects.none
            )
        Nop -> (m, Effects.none)

testButton : R.Comp Action Model
testButton =
    R.createClass
    { name = "Increment button"
    , render = \p ->
        R.html "button"
        [ R.EventAttribute "onClick" (Signal.message p.address Increment)
        ]
        [ R.text "Increment"
        ]
    }

testComp : R.Comp Action Model
testComp =
    R.createClass
    { name = "TestComp"
    , render = \p ->
        R.html "div" []
        [ R.text <| "Countervalue: " ++ toString p.model.counter
        , R.comp testButton p
        ]
    }

cfg : R.Config Model Action
cfg =
    { divId = "reactApp"
    , init = init
    , update = update
    , rootComponent = testComp
    , inputs = []
    }

app : R.App Model
app = R.start cfg

main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks = app.tasks