var submitAction = {
    registerSubmitAction: function (controller, action, form) {

        handler = function (event) {
            $(form)[0].submit();
        };

        eval('$(controller)[0].on' + action + ' = handler');
    }
}
