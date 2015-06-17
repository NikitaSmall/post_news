on_ready = function() {
    // begin search/archive tabs
    $('#archive-search-tabs a').click(function (e) {
        e.preventDefault();
        $(this).tab('show');
    });
    // END search/archive tabs

    // begin slider
    if ($(window).width() > 767){
        $('.fotorama-wrap').fotorama({
            width: '100%',
            maxwidth: '100%',
            nav: false,
            //autoplay: '4000',
            transitionduration: '850',
            click: false,
            swipe: false,
            loop: true,
            ratio: '1200/585'
        });
    } else {
        $(window).load(function () {
            var slideBlock = $('.fotorama-slide'),
                minHeight = 9999;
            slideBlock.each(function () {
                if ($(this).height() < minHeight){
                    minHeight = $(this).height();
                }
            });
            slideBlock.css({'height': minHeight, 'overflow': 'hidden'});
        });
    }

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
        if ($(window).width() > 768) {
            e.preventDefault();
            $(this).toggleClass('active');
            $('.wrapper').toggleClass('openedPopup');
            $('.popup-wrapper.popup-archive').toggleClass('open');
        }
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
            var offset = $('.popup-search .result-items-wrapper').offset().top;
            $('.popup-search .result-items-wrapper').css('height', (windowH-offset)+'px');
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

        }, 0);
    };

    $(window).load(function() {
        if ($(window).width() > 767){
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
        }


        // Begin РІРµСЂС‚РёРєР°Р»СЊРЅРѕРµ С†РµРЅС‚СЂРёСЂРѕРІР°РЅРёРµ С„РѕС‚РѕРє РІ news-item
        if ( $('.news-item').length > 0 ) {
            $('.news-item').each(function(){
                var $this = $(this);
                var itemHeight, imgHeight;
                itemHeight = $this.height();
                imgHeight = $this.find('img').height();
                if ( imgHeight > itemHeight ) {
                    $(this).find('img').css('margin-top', -(imgHeight-itemHeight)/2+ 'px');
                }
            });
        }
        // END РІРµСЂС‚РёРєР°Р»СЊРЅРѕРµ С†РµРЅС‚СЂРёСЂРѕРІР°РЅРёРµ С„РѕС‚РѕРє РІ news-item

       /* if ($(window).width() < 768){
            function setNewsItemHeight() {
                var newsItem = $('.news-item'),
                    minHeight = 9999;
                newsItem.each(function () {
                    var imgHeight = $(this).find('img').height();
                    if (imgHeight<minHeight) {
                        minHeight = imgHeight;
                    }
                });
                newsItem.find('.img-wrap').css('height', minHeight);
                newsItem.css('height', minHeight + 10);
                newsItem.find('.mobile').css('height', minHeight - 31);
            }
            setNewsItemHeight();
            $(window).resize(function () {
                setNewsItemHeight();
            })

        }*/

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

    function archiveOpen() {
        var windowHeight = $(window).height(),
            archiveHeight = $('.popup-archive-content').height();
        console.log(archiveHeight);
        if (windowHeight<archiveHeight) {
            $(".archiveSlimScroll").slimScroll({
                height: windowHeight + 'px',
                alwaysVisible: true
            });
        }
    }
    archiveOpen();



    function setNewsItemImgPosition() {
        $(window).load(function () {
            if ($(window).width() < 769) {
                var newsItem = $('.news-item');
                newsItem.each(function () {
                    var newsItem = $(this),
                        imgWrap = newsItem.children('.img-wrap'),
                        img = imgWrap.children('img'),
                        imgHeight,
                        imgWidth,
                        marLeft;
                    imgHeight = img.height();
                    console.log(imgHeight);
                    if (imgHeight < 122){
                        img.css({'height':'100%', 'max-width': 'none' , 'width': 'auto'});
                        imgWidth = img.width();
                        if (imgWidth > 150) {
                            marLeft = (imgWidth - 150)/2;
                            img.css('margin-left', -marLeft);
                        }
                    }
                });
            }
        });
    }

    setNewsItemImgPosition();


    var slideInfoTitle = $('.slide-info .title'),
        slideInfoText = $('.slide-info .text');
    function setupDotdotdot() {
        slideInfoTitle.css('height', '104px');
        slideInfoText.css('height', '111px');

        if ($(window).width() < 768){
            slideInfoTitle.css('height', '83px');
            slideInfoText.css('height', '67px');
            if ($(window).width() < 380) {
                slideInfoTitle.css('height', '38px');
                slideInfoText.css('height', '68px');
            }
            slideInfoText.dotdotdot();
        }
        if ($(window).width() < 992){
            slideInfoTitle.dotdotdot();
            slideInfoText.dotdotdot();
        }

        if ($(window).width() < 769){
            // begin news items
            var newsItem = $('.news-item'),
                newsItemTitle = newsItem.find('strong'),
                newsItemText = newsItem.find('.mobile');
            newsItemTitle.dotdotdot();
            newsItemText.dotdotdot();
            // END news items
        }


    }
    setupDotdotdot();
    $(window).resize(function() {
        setupDotdotdot();
        setNewsItemImgPosition();
    });

    if ($(window).width() < 769) {
        $('.archive-button').attr('href', 'http://apex-news.herokuapp.com/archive?utf8=%E2%9C%93&start_date=&end_date=');
    }
};

$(document).ready(on_ready);
$(document).on('page:load', on_ready);

