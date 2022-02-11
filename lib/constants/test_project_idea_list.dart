import '../models/project_pitch.dart';

List<ProjectIdea> get getList {
  return [...projects];
}

List projects = [
  ProjectIdea(
    id: "01",
    name: "Project 1 Name",
    description:
        "This is a sample project description that has a lot of words in it",
    askingPrice: 100000,
    equity: 0.03,
    owner: "test owner",
  ),
  ProjectIdea(
    id: "02",
    name: "Project 2 Name",
    description:
        "This is a sample project description that has a lot of words in it",
    askingPrice: 9000000,
    equity: 0.10,
    owner: "test owner 2",
  ),
  ProjectIdea(
    id: "03",
    name: "Project 3 Name",
    description:
        "This is a sample project description that has a lot of words in it",
    askingPrice: 45000,
    equity: 0.15,
    owner: "test owner 3",
  ),
];
