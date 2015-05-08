on_ready = function() {
    // begin search/archive tabs
    $('#archive-search-tabs a').click(function (e) {
        e.preventDefault();
        $(this).tab('show');
    });
    // END search/archive tabs

    // begin slider
    $('.fotorama').fotorama({
        width: '100%',
        maxwidth: '100%',
        nav: false,
        //autoplay: '3000',
        transitionduration: '850',
        loop: true,
        ratio: '1200/585'
    });
    // END slider


    // begin search and archive popups
    $('.js-search').on('click', function(e){
        e.preventDefault();
        $(this).toggleClass('active');
        $('.popup-wrapper.popup-search').toggleClass('open');
        $('.input-search').focus();
    });
    $('.js-archive').on('click', function(e){
        e.preventDefault();
        $(this).toggleClass('active');
        $('.popup-wrapper.popup-archive').toggleClass('open');
    });
    $('.popup-search .popup-close').on('click', function(e){
        e.preventDefault();
        $(this).closest('.popup-wrapper').toggleClass('open');
        $('.js-search').toggleClass('active');
    });
    $('.popup-archive .popup-close').on('click', function(e){
        e.preventDefault();
        $(this).closest('.popup-wrapper').toggleClass('open');
        $('.js-archive').toggleClass('active');
    });
    // END search and archive popups


    // begin последние новости слайдер
    var mySwiper = new Swiper ('.swiper-container', {
        direction: 'vertical',
        loop: true,
        autoplay: 5000,
        speed: 1300
    });
    // END последние новости слайдер
};

$(document).ready(on_ready);
$(document).on('page:load', on_ready);