class Location {
  String id;
  String name;
  double? latitude;
  double? longitude;
  String? description;
  String? photoUrl;
  String? createdBy;
  int? votes;
  double? grade;
  String? category;

  Location(
      this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.description,
      this.photoUrl,
      this.createdBy,
      this.votes,
      this.grade,
      this.category,
      );
}
