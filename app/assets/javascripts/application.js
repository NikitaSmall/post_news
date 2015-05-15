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
//= require jquery_ujs
//= require turbolinks
//= require ckeditor/init
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.validate.localization/messages_ru
//= require_tree ./ckeditor
//= require fotorama
//= require disqus_rails
//= require_tree .

jQuery.validator.addMethod('lettersonly', (function(value, element) {
    return this.optional(element) || /^[^0-9+-,!@#$%^&*();\/|<>]/i.test(value);
}), 'Первым символом может быть только буква');

jQuery.validator.addMethod('right_email', (function(value, element) {
    return this.optional(element) || /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/i.test(value);
}), 'Допустим только корректный электронный адрес');

on_ready = function(){
    window.disqus_no_style = true;
    //$.getScript("http://disqus.com/forums/rapexegesis/embed.js");
};

$(document).on('page:load', on_ready);
$(document).ready(on_ready);