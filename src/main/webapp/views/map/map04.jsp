<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
  #map04 > #map{
    width: 500px;
    height: 500px;
    border: 2px solid red;
  }
</style>

<script>
  let map04 = {
    map : null,
    init : function (){
      this.display();
      $('#s_btn').click(function (){
        map04.go(37.640446, 127.014702, 's');
      });
      $('#b_btn').click(function (){
        map04.go(35.1798456, 129.0705432, 'b');
      });
      $('#j_btn').click(function (){
        map04.go(33.4999002, 126.5341787, 'j');
      });
    },

    display : function (){
      var mapContainer = document.querySelector('#map04 > #map');
      var mapOption = {
        center: new kakao.maps.LatLng(37.5446864, 127.0582152),
        level: 5 // 지도의 확대 레벨
      };
      map = new kakao.maps.Map(mapContainer, mapOption);
      var mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      var zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      var markerPosition  = new kakao.maps.LatLng(37.5446864, 127.0582152);
      var marker = new kakao.maps.Marker({
        position: markerPosition
      });
      marker.setMap(map);
    },
    go:function (lat,lng,loc){
      var moveLatLon = new kakao.maps.LatLng(lat,lng);
      map.panTo(moveLatLon);

      var markerPosition  = new kakao.maps.LatLng(lat,lng);
      var marker = new kakao.maps.Marker({
        position: markerPosition
      });
      marker.setMap(map);
      map04.markers(loc);
    },
    markers:function (loc){
      $.ajax({
        url:'/markers',
        data:{'loc':loc},
        success:function(data){
          map04.displaymarkers(data);
        }
      });
    },
    displaymarkers:function(positions){
      var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";
      for (var i = 0; i < positions.length; i ++) {
        var imageSize = new kakao.maps.Size(20, 30);
        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
        var markerPosition = new kakao.maps.LatLng(positions[i].lat,positions[i].lng);

        var marker = new kakao.maps.Marker({
          map: map,
          position: markerPosition,
          title : positions[i].title,
          image : markerImage
        });
        // infoWindow
        var iwContent = '<h2>'+positions[i].title+'</h2>';
        iwContent += '<img src="/img/'+positions[i].img+'" style="width:50px">';

        var infowindow = new kakao.maps.InfoWindow({
          position : markerPosition,
          content : iwContent
        });

        kakao.maps.event.addListener(marker, 'mouseover', mouseoverListener(marker, infowindow));
        kakao.maps.event.addListener(marker, 'mouseout', mouseoutListener(marker, infowindow));
        kakao.maps.event.addListener(marker, 'click', mouseclickListener(positions[i].target));

        function mouseoverListener(marker, infowindow) {
          return function(){
            infowindow.open(map, marker);
          };
        }
        function mouseoutListener(marker, infowindow) {
          return function(){
            infowindow.close();
          };
        }
        function mouseclickListener(target) {
          return function(){
            location.href = target;
          };
        }
      }
    }
  };
  $(function(){
    map04.init();
  })
</script>

<div class="col-sm-8 text-left">
  <div class="container" id="map04">
    <h3>MAP04</h3>
    <button id="s_btn" type="button" class="btn btn-primary">Seoul</button>
    <button id="b_btn" type="button" class="btn btn-primary">Busan</button>
    <button id="j_btn" type="button" class="btn btn-primary">Jeju</button>
    <div id="map"></div>
  </div>
</div>