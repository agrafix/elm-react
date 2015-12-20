module React.Component
    ( Node, Component
    , ComponentSpec, createClass
    , comp
    , Attribute(..), html
    , text
    , renderTo
    ) where

{-| This module provides a low level wrapper around react functions.

# Core types
@docs Node, Component

# Defining components
@docs ComponentSpec, createClass

# Composing components
@docs comp, Attribute, html, text

# Rendering to div
@docs renderTo
-}

import Native.React

import Task
import Signal

{-| A node in the component tree -}
type Node = Node

{-| A component created with `createClass` -}
type Component props = Component

{-| A component spec -}
type alias ComponentSpec props =
    { name : String
    , render : props -> Node
    }

{-| Define a component given a `ComponentSpec` -}
createClass : ComponentSpec props -> Component props
createClass = Native.React.createClass

{-| Convert a component to a node -}
comp : Component props -> props -> Node
comp = Native.React.createElement

{-| An attribute for a HTML node -}
type Attribute
    = BasicAttribute String String
    | EventAttribute String Signal.Message

{-| Make an html node -}
html : String -> List Attribute -> List Node -> Node
html = Native.React.createHtmlElement

{-| Make a text node -}
text : String -> Node
text = Native.React.createTextElement

{-| Render node to a div -}
renderTo : String -> Node -> Task.Task never ()
renderTo = Native.React.renderTo