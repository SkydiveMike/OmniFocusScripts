JsOsaDAS1.001.00bplist00�Vscript_qfunction handle_string(argv) {
  //argv = ["ti"]
	searchTerm = new RegExp(argv, "i")
	app = Application('OmniFocus')
	projects = app.defaultDocument.flattenedFolders.whose({name: "Templates"})[0].projects()
	output = []

	projects.forEach(function(project) {
		if (project.name().match(searchTerm)) {
			output.push({"title": project.name()})
		}
	})
	
	return output
}                              � jscr  ��ޭ