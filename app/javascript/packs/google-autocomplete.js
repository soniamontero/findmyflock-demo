const googleLocation = () => {
  const el = document.getElementById('locality');
  if (!el) return;

  document.addEventListener("DOMContentLoaded", function(event){
    if (document.querySelector("#locality") != null) {
      var placeSearch,
        autocomplete;
      var componentForm = {
        locality: 'long_name',
        administrative_area_level_1: 'short_name',
        country: 'long_name',
        postal_code: 'short_name'
      };

      var options = {
        types: ['geocode'],
      }

      autocomplete = new google.maps.places.Autocomplete((el), options);

      if (autocomplete != null) {
        autocomplete.addListener('place_changed', function(){
          var place = autocomplete.getPlace();
          for (var i = 0; i < place.address_components.length; i++) {
            var addressType = place.address_components[i].types[0];
            if (componentForm[addressType]) {
              var val = place.address_components[i][componentForm[addressType]];
              document.getElementById(addressType).value = val;
            }
          }
        });
      }
    }
  })
}

export { googleLocation }
