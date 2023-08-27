class AgentsByTeam {
  String? name;
  List<AgentById>? agents;
  AgentsByTeam({
    this.name,
    this.agents,
  });
  factory AgentsByTeam.fromJson(
      {required String admin, required Map<String, dynamic> json}) {
    return AgentsByTeam(
        name: admin,
        agents: List.from(
            json.entries.map((e) => AgentById(id: e.key, name: e.value))));
  }
}

class AgentById {
  String? id;
  String? name;

  AgentById({
    this.id,
    this.name,
  });

  AgentById.fromJson(Map<String, dynamic> json) {
    id = json['id'].runtimeType == 0.runtimeType
        ? json['id'].toString()
        : json['id'];
    name = json['name'] ?? json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
