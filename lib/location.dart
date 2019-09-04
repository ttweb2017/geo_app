
class Terminal {
  int id;
  String terminalId;
  String owner;
  String address;
  double longitude;
  double altitude;
  bool status;
  String statusText;

  Terminal({
    this.id,
    this.terminalId,
    this.owner,
    this.address,
    this.longitude,
    this.altitude,
    this.status,
    this.statusText
  });


  factory Terminal.fromJson(Map<String, dynamic> json) {

    return Terminal(
        id: int.parse(json['id']),
        terminalId: json['terminal_id'],
        owner: json['owner'],
        address: json['address'],
        longitude: double.parse(json['longtitude']),
        altitude: double.parse(json['altitude']),
        status: json['status'] == "1" ? true : false,
        statusText: json['status'] == "1" ? "Işjeň" : json['status'] == "0" ? "Işjeň däl" : "Näbelli"
    );
  }
}