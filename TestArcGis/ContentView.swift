import SwiftUI
import UIKit
import ArcGIS

struct ContentView: View {
    @StateObject private var mapViewModel = MapViewModel()
    let items = [
        (imageName: "tree.fill", value: "3.5", unit: "kg", points: "recycle"),
        (imageName: "leaf.fill", value: "4.2", unit: "g", points: "carbon"),
        (imageName: "waterbottle.fill", value: "5346", unit: "", points: "points")
    ]
    
    let pointItems = [
        (imageName: "1", name: "Plactic"),
        (imageName: "2", name: "Glass"),
        (imageName: "3", name: "Paper")
    ]
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                LazyVStack(alignment: .center) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(10)
                        HStack{
                            VStack(alignment: .leading) {
                                Text("User Name")
                                    .foregroundStyle(.black)
                                Text("Svyatoshin, 356")
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            .padding(.leading)
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(10)
                        }
                        .background(.white.opacity(0.6))
                        .cornerRadius(35)
                    }
                    HStack {
                        ForEach(items, id: \.value) { item in
                            VStack(alignment: .center) {
                                Image(systemName: item.imageName)
                                    .resizable()
                                    .frame(maxWidth: 25, maxHeight: 50)
                                    .padding(10)
                                HStack {
                                    Text(item.value)
                                    Text(item.unit)
                                }
                                Text(item.points)
                            }
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .padding(.horizontal, 20)
                            .background(.white.opacity(0.6))
                            .cornerRadius(35)
                        }
                    }
                    
                }
                .padding()
                .frame(height: 250)
                .background(.green.opacity(0.4))
                .cornerRadius(35)
                .padding()
                
                Section {
                    MapView()
                        .frame(height: 250)
                        .cornerRadius(35)
                        .padding()
                        .onTapGesture {
                            mapViewModel.isFullScreenPresented = true
                        }
                        .fullScreenCover(isPresented: $mapViewModel.isFullScreenPresented) {
                            VStack {
                                HStack {
                                    Button {
                                        mapViewModel.isFullScreenPresented = false
                                    } label: {
                                        Text("Back")
                                    }
                                    .padding()
                                    Spacer()
                                }
                                MapView()
                                    .onAppear {
                                        mapViewModel.loadMap()
                                    }
                            }
                        }
                } header: {
                    Text("Поруч з вами")
                        .padding(.leading, 20)
                        .bold()
                }
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(pointItems, id: \.name) { pointItem in
                                VStack(alignment: .center) {
                                    Image(pointItem.imageName)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .padding(10)
                                    Text(pointItem.name)
                                        .foregroundStyle(.black)
                                }
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .padding(.horizontal, 20)
                                .background(Color.white.opacity(0.6))
                                .cornerRadius(35)
                                .padding(.top, 10)
                            }
                        }
                    }
                } header: {
                    Text("Матеріали")
                        .padding(.leading, 20)
                        .bold()
                }
            }
            .environmentObject(mapViewModel)
            .onAppear {
                    mapViewModel.loadMap()
                
            }
        }

    }
}

struct Map: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview {
    ContentView()
}

struct MapView: UIViewRepresentable {
    @EnvironmentObject var viewModel: MapViewModel

    func makeUIView(context: Context) -> AGSMapView {
        let mapView = AGSMapView()
        let graphicsOverlay = AGSGraphicsOverlay()
        mapView.graphicsOverlays.add(graphicsOverlay)
        return mapView
    }

    func updateUIView(_ uiView: AGSMapView, context: Context) {
        // Оновлюємо мапу лише якщо вона завантажена
        if let map = viewModel.map {
            uiView.map = map
            viewModel.addContainerLocations(to: uiView)
        }
    }
}

class MapViewModel: ObservableObject {
    @Published var map: AGSMap?
    @Published var isFullScreenPresented = false

    func loadMap() {
        // Завантажуємо карту з певним типом базової карти
        map = AGSMap(basemapType: .streets, latitude: 50.4501, longitude: 30.5234, levelOfDetail: 10)
    }

    func addContainerLocations(to mapView: AGSMapView) {
        // Контейнери
        let containerLocations = [
            (latitude: 50.4501, longitude: 30.5234), // Хрещатик
            (latitude: 50.4494, longitude: 30.5154), // Бульвар Тараса Шевченка
            (latitude: 50.4497, longitude: 30.4916)  // Січових Стрільців
        ]

        if let graphicsOverlay = mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay {
            graphicsOverlay.graphics.removeAllObjects()

            for location in containerLocations {
                let point = AGSPoint(x: location.longitude, y: location.latitude, spatialReference: .wgs84())

                if let symbolImage = UIImage(named: "iconMarker") {
                    let symbol = AGSPictureMarkerSymbol(image: symbolImage)
                    symbol.width = 30
                    symbol.height = 30
                    
                    let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: nil)
                    graphicsOverlay.graphics.add(graphic)
                } else {
                    print("Не вдалося завантажити зображення iconMarker")
                }
            }
        }
    }
}
