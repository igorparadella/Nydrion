class_name ODTGenerator
extends RefCounted


var textos: Array[String] = []
var titulo: String = ""


func set_title(texto: String) -> void:
	titulo = texto


func add_text(texto: String) -> void:
	textos.append(texto)


func add_title(texto: String) -> void:
	textos.append("###TITULO###" + texto)


func save(caminho: String) -> bool:
	var zip := ZIPPacker.new()

	var erro := zip.open(caminho)

	if erro != OK:
		push_error("Não foi possível criar o arquivo ODT.")
		return false

	# =========================================================
	# MIMETYPE
	# =========================================================

	zip.start_file("mimetype")

	var mimetype := "application/vnd.oasis.opendocument.text"
	zip.write_file(mimetype.to_utf8_buffer())

	# =========================================================
	# CONTENT.XML
	# =========================================================

	zip.start_file("content.xml")

	var content := _criar_content_xml()
	zip.write_file(content.to_utf8_buffer())

	# =========================================================
	# STYLES.XML
	# =========================================================

	zip.start_file("styles.xml")

	var styles := _criar_styles_xml()
	zip.write_file(styles.to_utf8_buffer())

	# =========================================================
	# META.XML
	# =========================================================

	zip.start_file("meta.xml")

	var meta := _criar_meta_xml()
	zip.write_file(meta.to_utf8_buffer())

	# =========================================================
	# SETTINGS.XML
	# =========================================================

	zip.start_file("settings.xml")

	var settings := _criar_settings_xml()
	zip.write_file(settings.to_utf8_buffer())

	# =========================================================
	# MANIFEST
	# =========================================================

	zip.start_file("META-INF/manifest.xml")

	var manifest := _criar_manifest_xml()
	zip.write_file(manifest.to_utf8_buffer())

	# =========================================================
	# FECHAR ZIP
	# =========================================================

	zip.close()

	print("ODT criado com sucesso:")
	print(caminho)

	return true


# =============================================================
# CONTENT.XML
# =============================================================

func _criar_content_xml() -> String:

	var xml := """<?xml version="1.0" encoding="UTF-8"?>
<office:document-content
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
office:version="1.2">

<office:automatic-styles>

<style:style
style:name="Titulo"
style:family="paragraph">

<style:text-properties
fo:font-size="20pt"
fo:font-weight="bold"/>

</style:style>


<style:style
style:name="Subtitulo"
style:family="paragraph">

<style:text-properties
fo:font-size="14pt"
fo:font-weight="bold"/>

</style:style>

</office:automatic-styles>


<office:body>

<office:text>
"""

	# =========================================================
	# TÍTULO PRINCIPAL
	# =========================================================

	if titulo != "":
		xml += '<text:p text:style-name="Titulo">'
		xml += _escapar_xml(titulo)
		xml += "</text:p>\n"


	# =========================================================
	# TEXTOS
	# =========================================================

	for texto in textos:

		if texto.begins_with("###TITULO###"):

			var titulo_texto := texto.trim_prefix("###TITULO###")

			xml += '<text:p text:style-name="Subtitulo">'
			xml += _escapar_xml(titulo_texto)
			xml += "</text:p>\n"

		else:

			xml += "<text:p>"
			xml += _escapar_xml(texto)
			xml += "</text:p>\n"


	xml += """
</office:text>

</office:body>

</office:document-content>
"""

	return xml


# =============================================================
# STYLES.XML
# =============================================================

func _criar_styles_xml() -> String:

	return """<?xml version="1.0" encoding="UTF-8"?>

<office:document-styles
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
office:version="1.2">

<office:styles>

</office:styles>

</office:document-styles>
"""


# =============================================================
# META.XML
# =============================================================

func _criar_meta_xml() -> String:

	return """<?xml version="1.0" encoding="UTF-8"?>

<office:document-meta
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
xmlns:dc="http://purl.org/dc/elements/1.1/"
office:version="1.2">

<office:meta>

<dc:title>
Documento NutriPro
</dc:title>

</office:meta>

</office:document-meta>
"""


# =============================================================
# SETTINGS.XML
# =============================================================

func _criar_settings_xml() -> String:

	return """<?xml version="1.0" encoding="UTF-8"?>

<office:document-settings
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
office:version="1.2">

<office:settings>

</office:settings>

</office:document-settings>
"""


# =============================================================
# MANIFEST.XML
# =============================================================

func _criar_manifest_xml() -> String:

	return """<?xml version="1.0" encoding="UTF-8"?>

<manifest:manifest
xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"
manifest:version="1.2">

<manifest:file-entry
manifest:full-path="/"
manifest:media-type="application/vnd.oasis.opendocument.text"/>

<manifest:file-entry
manifest:full-path="content.xml"
manifest:media-type="text/xml"/>

<manifest:file-entry
manifest:full-path="styles.xml"
manifest:media-type="text/xml"/>

<manifest:file-entry
manifest:full-path="meta.xml"
manifest:media-type="text/xml"/>

<manifest:file-entry
manifest:full-path="settings.xml"
manifest:media-type="text/xml"/>

</manifest:manifest>
"""


# =============================================================
# ESCAPAR XML
# =============================================================

func _escapar_xml(texto: String) -> String:

	return texto \
		.replace("&", "&amp;") \
		.replace("<", "&lt;") \
		.replace(">", "&gt;") \
		.replace("\"", "&quot;") \
		.replace("'", "&apos;")
