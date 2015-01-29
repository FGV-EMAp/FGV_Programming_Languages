from kivy.garden.mapview import MapView
from kivy.app import App
#from mapview.geojson import GeoJsonMapLayer

class MapViewApp(App):
    def build(self):
        mapview = MapView(zoom=11, lat=-22.6394, lon=-45.057)
        return mapview

MapViewApp().run()