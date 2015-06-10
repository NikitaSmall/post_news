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
        autoplay: '4000',
        transitionduration: '850',
        click: false,
        swipe: false,
        loop: true,
        ratio: '1200/585'
    });
    // END slider


    // begin search and archive popups
    $('.js-search').on('click', function(e){
        e.preventDefault();
        $(this).toggleClass('active');
        $('.wrapper').toggleClass('openedPopup');
        $('.popup-wrapper.popup-search').toggleClass('open');
        $('.input-search').focus();
    });
    $('.js-archive').on('click', function(e){
        e.preventDefault();
        $(this).toggleClass('active');
        $('.wrapper').toggleClass('openedPopup');
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


    // begin РїРѕСЃР»РµРґРЅРёРµ РЅРѕРІРѕСЃС‚Рё СЃР»Р°Р№РґРµСЂ
    var mySwiper = new Swiper ('.swiper-container', {
        direction: 'vertical',
        loop: true,
        autoplay: 5000,
        speed: 1300
    });
    // END РїРѕСЃР»РµРґРЅРёРµ РЅРѕРІРѕСЃС‚Рё СЃР»Р°Р№РґРµСЂ


    $('.search-btn').on('click', function () {
        $('.search-results-wrap').toggle(true); // добавил true, чтобы она не опускалась после первого нажатия
        $('.popup-search-content').addClass('active'); // изменил, чтобы лишний раз не нажимать поиск
        // 50-я строка в style.css закоментирована, чтобы не исчезал ползунок (очень просили)
        setHeightResultsWrap();
    });

    var setHeightResultsWrap = function () {
        setTimeout(function () {
            var windowH = $(window).height();
            var offset = $('.result-items-wrapper').offset().top;
            $('.result-items-wrapper').css('height', (windowH-offset)+'px');
        }, 300);

        setTimeout(function () {
            $(".slimScroll").slimScroll({
                height: '450px',
                alwaysVisible: true
            });
            $( document ).ajaxComplete(function() {
                $(".slimScroll").slimScroll({
                    height: '450px',
                    alwaysVisible: true
                });
            });

            console.log('yup!!');
        }, 0);
    };


    $(window).load(function() {
        $('.news-item-row').each(function() {
            var minHeight = 9999;
            var childItem = $(this).children('.news-item');
            childItem.each(function () {
                var $this = $(this);
                var itemHeight = $this.height();
                if (itemHeight < minHeight){
                    minHeight = $(this).height();
                }

            });
            childItem.css('height', minHeight + 'px');

        });


        // Begin РІРµСЂС‚РёРєР°Р»СЊРЅРѕРµ С†РµРЅС‚СЂРёСЂРѕРІР°РЅРёРµ С„РѕС‚РѕРє РІ news-item
        if ( $('.news-item').length > 0 ) {
            $('.news-item').each(function(){
                var $this = $(this);
                var itemHeight, imgHeight;
                itemHeight = $this.height();
                imgHeight = $this.children('img').height();
                if ( imgHeight > itemHeight ) {
                    $(this).find('img').css('margin-top', -(imgHeight-itemHeight)/2+ 'px');
                }
            });
        }
        // END РІРµСЂС‚РёРєР°Р»СЊРЅРѕРµ С†РµРЅС‚СЂРёСЂРѕРІР°РЅРёРµ С„РѕС‚РѕРє РІ news-item

        // Begin РІРµСЂС‚РёРєР°Р»СЊРЅРѕРµ С†РµРЅС‚СЂРёСЂРѕРІР°РЅРёРµ С„РѕС‚РѕРє РІ СЃР»Р°Р№РґРµСЂРµ
        if ( $('.fotorama-slide').length > 0 ) {
            $('.fotorama-slide').each(function(){
                var $this = $(this);
                var itemHeight, imgHeight;
                itemHeight = $this.height();
                imgHeight = $this.find('img').height();
                if ( imgHeight > itemHeight ) {
                    $(this).children('img').css('margin-top', -(imgHeight-itemHeight)/2+ 'px');
                }
            });
        }
        // END РІРµСЂС‚РёРєР°Р»СЊРЅРѕРµ С†РµРЅС‚СЂРёСЂРѕРІР°РЅРёРµ С„РѕС‚РѕРє РІ СЃР»Р°Р№РґРµСЂРµ
    });


};

$(document).ready(on_ready);
$(document).on('page:load', on_ready);

$(window).load(function () {
    $('#dateRangePicker').dateRangePicker({
        inline:true,
        container: '#dateRangePicker',
        alwaysOpen:true,
        endDate: '[today]',
        format: 'YYYY-MM-DD',
        shortcuts : {
            'prev-days': [3,5,7],
            'next-days':null,
            'next':null
        }
    });
})
