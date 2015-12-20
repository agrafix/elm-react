var React = require("react");
var ReactDOM = require("react-dom");
var PureRenderMixin = require("react-addons-pure-render-mixin");

Elm.Native.React = {};
Elm.Native.React.make = function(elm)
{
    elm.Native = elm.Native || {};
    elm.Native.React = elm.Native.React || {};
    if (elm.Native.React.values)
    {
        return elm.Native.React.values;
    }

    var List = Elm.Native.List.make(elm);
    var Task = Elm.Native.Task.make(elm);
    var Signal = Elm.Native.Signal.make(elm);

    function createClass(spec) {
        return React.createClass({
            mixins: [PureRenderMixin],
            displayName: spec.name,
            render: function() {
                return spec.render(this.props);
            }
        })
    }

    function createElement(node, props) {
        return React.createElement(node, props);
    }

    function createHtmlElement(node, attribs, children) {
        var arr = List.toArray(attribs);
        var props = {};
        for (var i in arr) {
            var p = arr[i];
            if (p.ctor === 'BasicAttribute') {
                props[p._0] = p._1;
            } else if (p.ctor === 'EventAttribute') {
                props[p._0] = function (e) {
                    e.preventDefault();
                    Signal.sendMessage(p._1);
                }
            } else {
                throw new Error("Unknown attribute!");
            }
        }
        return React.createElement(node, props, List.toArray(children));
    }

    function createTextElement(txt) {
        return txt; // is this right?
    }

    function renderTo(divId, node) {
        var target = document.getElementById(divId);
        ReactDOM.render(node, target);
        return Task.succeed();
    }

    return Elm.Native.React.values = {
        createClass: createClass,
        createElement: F2(createElement),
        createHtmlElement: F3(createHtmlElement),
        createTextElement: createTextElement,
        renderTo: F2(renderTo)
    };
}
