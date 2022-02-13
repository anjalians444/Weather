class ForcastModel {
  Coord? coord;
  List<ForcastListModel>? list;

  ForcastModel({this.coord, this.list});

  ForcastModel.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? new Coord.fromJson(json['coord']) : null;
    if (json['list'] != null) {
      list = <ForcastListModel>[];
      json['list'].forEach((v) {
        list!.add(new ForcastListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coord != null) {
      data['coord'] = this.coord!.toJson();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}

class ForcastListModel {
  MainModel? main;
  ComponentsModel? components;
  int? dt;

  ForcastListModel({this.main, this.components, this.dt});

  ForcastListModel.fromJson(Map<String, dynamic> json) {
    main = json['main'] != null ? new MainModel.fromJson(json['main']) : null;
    components = json['components'] != null
        ? new ComponentsModel.fromJson(json['components'])
        : null;
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.main != null) {
      data['main'] = this.main!.toJson();
    }
    if (this.components != null) {
      data['components'] = this.components!.toJson();
    }
    data['dt'] = this.dt;
    return data;
  }
}

class MainModel {
  String aqi;

  MainModel({required this.aqi});

  MainModel.fromJson(Map<String, dynamic> json) :
    aqi = json['aqi'].toString();


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aqi'] = this.aqi;
    return data;
  }
}

class ComponentsModel {
  String? co;
  String? no;
  String? no2;
  String? o3;
  String? so2;
  double? pm25;
  double? pm10;
  String? nh3;

  ComponentsModel(
      {this.co,
        this.no,
        this.no2,
        this.o3,
        this.so2,
        this.pm25,
        this.pm10,
        this.nh3});

  ComponentsModel.fromJson(Map<String, dynamic> json) {
    co = json['co'].toString();
    no = json['no'].toString();
    no2 = json['no2'].toString();
    o3 = json['o3'].toString();
    so2 = json['so2'].toString();
    pm25 = double.parse(json['pm2_5'].toString());
    pm10 = double.parse(json['pm10'].toString());
    nh3 = json['nh3'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['co'] = this.co;
    data['no'] = this.no;
    data['no2'] = this.no2;
    data['o3'] = this.o3;
    data['so2'] = this.so2;
    data['pm2_5'] = this.pm25;
    data['pm10'] = this.pm10;
    data['nh3'] = this.nh3;
    return data;
  }
}