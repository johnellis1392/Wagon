
var CSVData = React.createClass({
    getInitialState: function() {
        return {};
    },

    componentDidMount: function() {
        this.setState({}); 
    },

    render: function() {
        var lines = this.props.data.split("\n").map(function(item) { 
            return <CSVLine data={item}/>; 
        });

        var header = <CSVHeader data={this.props.header}/>; 
        return (<div>{header}{lines}</div>); 
    }
});


var CSVHeader = React.createClass({
    getInitialState: function() {
        return {};
    },

    componentDidMount: function() {
        this.setState({});
    },

    render: function() {
        //console.log('CSVHeader Props: ', this.props); 
        var vals = this.props.data.split(',').map(function(item) {
            return <div style="margin-right:3%;">{item}</div>; 
        }).join(',');

        return <div>{vals}<br/></div>;
    }
});


var CSVHeaderCell = React.createClass({
    getInitialState: function() {
        return {}; 
    },

    componentDidMount: function() {
        this.setState({}); 
    },

    render: function() {
        return <div>{this.props.data}<br/></div>; 
    } 
});


var CSVLine = React.createClass({
    getInitialState: function() {
        return {};
    },

    componentDidMount: function() {
        this.setState({});
    },

    render: function() {
        var vals = this.props.data.split(',').map(function(item) {
            return <div style="margin-right:3%;">{item}</div>; 
        }).join(',');

        return <div>{vals}<br/></div>;
    }
});


var CSVVal = React.createClass({
    getInitialState: function() {
        return {};
    },

    componentDidMount: function() {
        this.setState({});
    },

    render: function() {
        return (<div><label></label></div>);
    }
});


var input = '/public/input.csv';
//var header = '"header (text)"'; 
//var body = 'asdhjrnvmc'; 
//React.render(<CSVData header={header} data={body}/>, document.getElementById('body'));
$.get(input, function(result) {
    //console.log('Results: ', result); 
    var data = result.split("\n");
    var header = data.pop();
    var body = data.join("\n"); 
    React.render(<CSVData header={header} data={body}/>, document.getElementById('body'));
});


