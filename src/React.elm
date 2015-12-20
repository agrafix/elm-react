module React
    ( CompProps, Comp, CompSpec
    , Config, App
    , start
    ) where

{-| High level bindings to facebook react library in the spirit of [start-app][sa].

[sa]: https://github.com/evancz/start-app

# Define components
@docs CompProps, Comp, CompSpec

# Start your Application
@docs Config, App, start
-}

import React.Component as R

import Task
import Effects exposing (Effects, Never)
import Graphics.Element as E

{-| Every component will take these props -}
type alias CompProps action model =
    { address: Signal.Address action
    , model: model
    }

{-| A component -}
type alias Comp action model = R.Component (CompProps action model)

{-| A component spec -}
type alias CompSpec action model = R.ComponentSpec (CompProps action model)

{-| The configuration of an app follows the basic model / update / view pattern
that you see in every Elm program.
The `divId` will identify the HTML div where React should render your application to. Make sure
this application exists before including elm in your application. This div must not be the same
div Elm will target.
The `init` transaction will give you an initial model and create any tasks that
are needed on start up.
The `update` and `view` fields describe how to step the model and view the
model.
The `inputs` field is for any external signals you might need. If you need to
get values from JavaScript, they will come in through a port as a signal which
you can pipe into your app as one of the `inputs`.
-}
type alias Config model action =
    { divId: String
    , init : (model, Effects action)
    , update : action -> model -> (model, Effects action)
    , rootComponent : Comp action model
    , inputs : List (Signal.Signal action)
    }

{-| An `App` is made up of a couple signals:
  * `html` &mdash; a constant empty `Element` to satisfy Elm's main function type.
  * `model` &mdash; a signal representing the current model. Generally you
    will not need this one, but it is there just in case. You will know if you
    need this.
  * `tasks` &mdash; a signal of tasks that need to get run. Your app is going
    to be producing tasks in response to all sorts of events, so this needs to
    be hooked up to a `port` to ensure they get run.
-}
type alias App model =
    { html : E.Element
    , model : Signal model
    , tasks : Signal (Task.Task Never ())
    }

{-| Start an application. It requires a bit of wiring once you have created an
`App`. It should pretty much always look like this:
    app =
        start { divId = "reactApp", init = init, update = update, rootComponent = comp, inputs = [] }
    main =
        app.html
    port tasks : Signal (Task.Task Never ())
    port tasks =
        app.tasks
So once we start the `App` we feed the HTML into `main` and feed the resulting
tasks into a `port` that will run them all.
-}
start : Config model action -> App model
start config =
    let singleton action = [ action ]
        messages =
            Signal.mailbox []
        address =
            Signal.forwardTo messages.address singleton
        updateStep action (oldModel, accumulatedEffects) =
            let
                (newModel, additionalEffects) = config.update action oldModel
            in
                (newModel, Effects.batch [accumulatedEffects, additionalEffects])
        update actions (model, _) =
            List.foldl updateStep (model, Effects.none) actions
        inputs =
            Signal.mergeMany (messages.signal :: List.map (Signal.map singleton) config.inputs)
        effectsAndModel =
            Signal.foldp update config.init inputs
        model =
            Signal.map fst effectsAndModel
        taskMaker (currentModel, pendingEffects) =
            R.renderTo config.divId (R.comp config.rootComponent { address = address, model = currentModel })
            `Task.andThen` \_ -> Effects.toTask messages.address pendingEffects
    in { html = E.empty
       , model = model
       , tasks = Signal.map taskMaker effectsAndModel
       }