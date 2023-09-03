
class Data {
  final String name;
  final Sys sys;
  final Wind wind;
  final Main main;
  final List<Weather> weatherList;
  final num dt;

  Data(this.name, this.sys, this.wind, this.main, this.weatherList, this.dt);

  static List<Weather> fromListOfDynamic(List<dynamic> dynamicList) {
    return dynamicList.map((e) {
      return Weather.fromJSON(e);
    }).toList();
  }

  factory Data.fromJSON(dynamic json) {

    return Data(
      json["name"],
      Sys.fromJSON(json["sys"]),
      Wind.fromJSON(json["wind"]),
      Main.fromJSON(json["main"]),
      Data.fromListOfDynamic(json["weather"]),
      json["dt"],
    );
  }
}

class Sys {
  final String country;
  final num sunrise;
  final num sunset;

  Sys(this.country, this.sunrise, this.sunset);

  factory Sys.fromJSON(dynamic json) {
    return Sys(
      json["country"],
      json["sunrise"],
      json["sunset"],
    );
  }
}

class Wind {
  final num speed;
  final num deg;

  Wind(this.speed, this.deg);

  factory Wind.fromJSON(dynamic json) {
    return Wind(
      json["speed"],
      json["deg"],
    );
  }
}

class Main {
  final num temp;
  final num feelsLike;
  final num tempMin;
  final num tempMax;
  final num pressure;
  final num humidity;

  Main(this.temp, this.feelsLike, this.tempMin, this.tempMax, this.pressure,
      this.humidity);
  
  factory Main.fromJSON(dynamic json) {
    
    return Main(
      json["temp"], 
      json["feels_like"], 
      json["temp_min"], 
      json["temp_max"], 
      json["pressure"], 
      json["humidity"],
    );
  }
}

class Weather {
  final String main;
  final String description;
  final String icon;

  Weather(this.main, this.description, this.icon);

  factory Weather.fromJSON(dynamic json) {
    return Weather(
      json["main"],
      json["description"],
      json["icon"],
    );
  }
}