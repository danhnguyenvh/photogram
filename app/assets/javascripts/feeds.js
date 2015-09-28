  var data_json = "";
  var page = 1;
  var current_page = 1;
  var total_page = 1;
  var pageSize = 20;
  function submitSearch(){
    var lat = $.trim($("#lat").val());
    var lng = $.trim($("#lng").val());
    var distance = $.trim($("#distance").val());
    if (lat != "" && lng != "")
      {
      	var url = "/feeds/search?lat="+lat+"&lng="+lng;
        if (distance != "") {
          url = url + "&distance=" + distance;
        }
      	$.get(url, function(data, status){
          if (status=='success'){
            page = 1;
            data_json = data.photos;
            loadCarousel(data_json);
            loadPaging(data_json, page);
            initPagingBar(data_json, pageSize);
            loadMap(data_json);
            if (data_json.length > 0){
              $('#noResult').html("");
            }
            else
            {
              $('#noResult').html("No result");
            }
          }
        });
      }
  }
  
  function loadPaging(data, page) {
    var html = "";
    var i = (page-1)*pageSize;
    var index = page * pageSize;
    var data_len = data.length;
    if ( index > data_len ){
      index = data_len;
    }
    for(; i<index; i++){
      html += "<span><img src="+data[i].thumbnail+" width='150px' height='150px' title='"+data[i].location_name+"'/></span>";
    }
   $(".tbl_data").html(html);
  }

  function loadCarousel(data){
    var thumbnail = "";
    var large = "";
    for(var i = 0; i < data.length; i++){
      thumbnail += "<li><img src="+data[i].thumbnail+" width='50px' height='50px' title='"+data[i].location_name+"' ></li>";
      large += "<li><img src="+data[i].standard_resolution+" width='440px' height='440px' title='"+data[i].location_name+"' ></li>";
    }
    $('.carousel-stage ul').html(large);
    $('.carousel-navigation ul').html(thumbnail);
    reloadCarousel();
   }
  var connector = function(itemNavigation, carouselStage) {
     return carouselStage.jcarousel('items').eq(itemNavigation.index());
  };

  function reloadCarousel(){
    var carouselStage      = $('.carousel-stage').jcarousel();
    var carouselNavigation = $('.carousel-navigation').jcarousel();

    // We loop through the items of the navigation carousel and set it up
    // as a control for an item from the stage carousel.
    carouselNavigation.jcarousel('items').each(function() {
        var item = $(this);

        // This is where we actually connect to items.
        var target = connector(item, carouselStage);

        item
            .on('jcarouselcontrol:active', function() {
                carouselNavigation.jcarousel('scrollIntoView', this);
                item.addClass('active');
            })
            .on('jcarouselcontrol:inactive', function() {
                item.removeClass('active');
            })
            .jcarouselControl({
                target: target,
                carousel: carouselStage
            });
    });
  }

  function loadMap(data){
    var json_str = [];
    var len = data.length;
    for(var i = 0; i < len; i++){
      json_str.push({
        lat: data[i].lat,
        lng: data[i].lng,
        infowindow: data[i].location_name
      });
    }
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
      markers = handler.addMarkers(json_str);
      handler.bounds.extendWith(markers);
      handler.fitMapToBounds();
    });
  }

  function loadChangePage(page){
    current_page = page;
    loadPaging(data_json, page);
    $('.num_page').removeClass('active');
    $('.paging_bar #page_'+page+'').addClass('active');
  }

  function initPagingBar(data, pageSize){
    var page = 1;
    var len = data.length;
    var mod = len % pageSize;
    var res = parseInt(len / pageSize);
    if (mod == 0) {
      page = res ;
    } else {
      page = res + 1;
    }
    total_page = page;
    var html = "";
    if (len > 0){
      html += "<span class='pre_page num_page' onClick='onChangePage(0)' ><< </span>";
      for (var i = 1; i <= page;i++)
      {
        if (i==1) {
          html += " <span id='page_"+i.toString()+"' class='num_page active' onClick='loadChangePage("+i+")'>"+i.toString()+"</span>";
        } else {
          html += " <span id='page_"+i.toString()+"' class='num_page' onClick='loadChangePage("+i+")'>"+i.toString()+"</span>";
        }
      }
      html += "<span class='next_page num_page' onClick='onChangePage(1)'> >></span>"
    }
    $(".paging_bar").html(html);
  }

  function onChangePage(next_pre){
    if (next_pre == 1){
      if (current_page < total_page){
        current_page = current_page + 1;
      }
    } else {
      if (current_page > 1){
        current_page = current_page - 1;
      }
    }
    loadChangePage(current_page);
  }
  