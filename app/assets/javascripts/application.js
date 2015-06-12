// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
// require jquery_ui
//= require jquery_ujs
//= require turbolinks
//= require ckeditor/init
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.validate.localization/messages_ru
// require ckeditor/config
//= require fotorama
//= require disqus_rails
//= require social-share-button
//= require moment.min
//= require jquery.daterangepicker
//= require_tree .

jQuery.validator.addMethod('lettersonly', (function(value, element) {
    return this.optional(element) || /^[^0-9+-,!@#$%^&*();\/|<>]/i.test(value);
}), 'Первым символом может быть только буква');

jQuery.validator.addMethod('right_email', (function(value, element) {
    return this.optional(element) || /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/i.test(value);
}), 'Допустим только корректный электронный адрес');

var string = "";
var first = 1;

on_ready = function(){
    window.disqus_no_style = true;
    //$.getScript("http://disqus.com/forums/rapexegesis/embed.js");

    $(document).keyup(function(e){
        string+= e.which.toString();

        if((string.indexOf('38384040373937396665') + 1) && first == 1) {
            $('body').append("<div id='easter-2' style='position: fixed; right: 50%; bottom: 105%; font-size: 20px;'>Фин! Сражайся честно, несносный мальчишка!</div>");
            $('#easter').animate({bottom:'0px'}, {duration:600});
            $('#easter-2').animate({bottom:'-50px'}, {duration:5000});
            $('#easter').animate({bottom:'-10px'}, {duration:300});
            $('#easter').animate({bottom:'0px'}, {duration:300});
            $('#easter').animate({bottom:'-15px'}, {duration:300});
            $('#easter').animate({bottom:'-5px'}, {duration:300});
            $('#easter').animate({bottom:'-10px'}, {duration:300});
            $('#easter').animate({bottom:'0px'}, {duration:300});
            $('#easter').animate({bottom:'-10px'}, {duration:300});
            $('#easter').animate({bottom:'0px'}, {duration:300});
            $('#easter').animate({bottom:'-30px'}, {duration:300});
            $('#easter').animate({bottom:'-250px'}, {duration:500});
            first = 0;
        }
    });
};

$(document).on('page:load', on_ready);
$(document).ready(on_ready);