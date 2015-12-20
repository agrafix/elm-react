# elm-react

This is currently only a proof of concept: Build [React][react] applications using [Elm][elm]. This works better than I expected.

## What's included?

Currently this elm packages includes a mixture of something like [start-app][start-app] and [elm-html][elm-html], but instead of relying on `virtual-dom` the whole thing is built using `react`. Currently react components are used for the view part, and state is handled outside as suggested in [the Elm Architecture][elm-arch].

## Tutorial / Example

Example react component:

```elm
testComp : R.Comp Action Model
testComp =
    R.createClass
    { name = "TestComp"
    , render = \p ->
        R.html "div" []
        [ R.text <| "Countervalue: " ++ toString p.model.counter
        , R.html "button"
            [ R.EventAttribute "onClick" (Signal.message p.address Increment)
            ]
            [ R.text "Increment"
            ]
        ]
    }
```

To see how everything works in detail, check out the `example` folder and the `make-example.sh` script to build it.

## Next steps

* Support more react life-cycle events like `componentDidMount` and `componentWillUnmount` to support hooking 3rd Party libs like `leaflet`
* Support for transitions
* Define helper functions for html nodes and attributes
* Figure out if there's a way to avoid the 'external div' hack
* I'm not sure how everything will integrate with [the Elm Architecture][elm-arch]. From the first point of view it seems to go very well, but I have not explored it in depth yet.
* Split into two packages: `elm-react` and `react-start-app`
* Split out the DOM parts to allow building apps with `react-native`

## Contributing / Helping / Hacking

If you like to help, please open an issue about what you will do and send a pull request when finished! Code should be written in a consistent style throughout the project. Avoid whitespace that is sensible to conflicts. Note that by sending a pull request you agree that your contribution can be released under the BSD3 License as part of the `elm-react` package or any related packages.

### Building the library

```bash
$ npm install
$ ./rebuild.sh
$ elm make
```

[react]: https://facebook.github.io
[elm]: http://elm-lang.org/
[start-app]: https://github.com/evancz/start-app
[elm-html]: https://github.com/evancz/elm-html
[elm-arch]: https://github.com/evancz/elm-architecture-tutorial/