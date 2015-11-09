# jQuery ->
#   init = ->
#     # Создаем карту:
#     myMap = new ymaps.Map("map",
#       center: [
#         55.644992
#         37.641087
#       ]
#       zoom: 17
#     )

#     # Создаем метку:
#     myPlacemark = new ymaps.Placemark([
#       55.644992
#       37.641087
#     ],
#       hintContent: "Spine-Sport"
#       balloonContent: "Spine-Sport"
#     )

#     # Добавляем метку накарту:
#     myMap.geoObjects.add myPlacemark

#   myMap = undefined
#   ymaps.ready init
