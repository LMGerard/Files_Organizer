import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'checkbox.dart';

class ExtensionsPanel extends StatefulWidget {
  final Map<String, CheckBox> _extensions = {
    'unlisted': CheckBox(label: 'include unlisted', value: true),
  };

  Map<String, bool> get extensions =>
      _extensions.map((key, value) => MapEntry(key, value.value));

  ExtensionsPanel({Key? key}) : super(key: key) {
    for (final i in EXTENSIONS) {
      _extensions[i] = CheckBox(label: i);
    }
  }

  @override
  State<ExtensionsPanel> createState() => _ExtensionsPanelState();
}

class _ExtensionsPanelState extends State<ExtensionsPanel> {
  bool isExpanded = false;
  String searchKey = '';
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const Text(
        'Exensions:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      collapsed: Container(),
      expanded: SizedBox(
        height: 200,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Search extensions',
              ),
              onChanged: (value) {
                setState(() {
                  searchKey = value;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget._extensions.values
                      .where((e) => e.label.contains(searchKey))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const EXTENSIONS = [
  "doc",
  "docx",
  "log",
  "msg",
  "odt",
  "pages",
  "rtf",
  "tex",
  "txt",
  "wpd",
  "wps",
  "csv",
  "dat",
  "ged",
  "key",
  "keychain",
  "ppt",
  "pptx",
  "sdf",
  "tar",
  "tax2016",
  "tax2020",
  "vcf",
  "xml",
  "aif",
  "iff",
  "m3u",
  "m4a",
  "mid",
  "mp3",
  "mpa",
  "wav",
  "wma",
  "3g2",
  "3gp",
  "asf",
  "avi",
  "flv",
  "m4v",
  "mov",
  "mp4",
  "mpg",
  "rm",
  "srt",
  "swf",
  "vob",
  "wmv",
  "3dm",
  "3ds",
  "max",
  "obj",
  "bmp",
  "dds",
  "gif",
  "heic",
  "jpg",
  "png",
  "psd",
  "pspimage",
  "tga",
  "thm",
  "tif",
  "tiff",
  "yuv",
  "ai",
  "eps",
  "svg",
  "indd",
  "pct",
  "pdf",
  "xlr",
  "xls",
  "xlsx",
  "accdb",
  "db",
  "dbf",
  "mdb",
  "pdb",
  "sql",
  "apk",
  "app",
  "bat",
  "cgi",
  "com",
  "exe",
  "gadget",
  "jar",
  "wsf",
  "b",
  "dem",
  "gam",
  "nes",
  "rom",
  "sav",
  "dwg",
  "dxf",
  "gpx",
  "kml",
  "kmz",
  "asp",
  "aspx",
  "cer",
  "cfm",
  "crdownload",
  "csr",
  "css",
  "dcr",
  "htm",
  "html",
  "js",
  "jsp",
  "php",
  "rss",
  "xhtml",
  "crx",
  "plugin",
  "fnt",
  "fon",
  "otf",
  "ttf",
  "cab",
  "cpl",
  "cur",
  "deskthemepack",
  "dll",
  "dmp",
  "drv",
  "icns",
  "ico",
  "lnk",
  "sys",
  "cfg",
  "ini",
  "prf",
  "hqx",
  "mim",
  "uue",
  "7z",
  "cbr",
  "deb",
  "gz",
  "pkg",
  "rar",
  "rpm",
  "sitx",
  "tar.gz",
  "zip",
  "zipx",
  "bin",
  "cue",
  "dmg",
  "iso",
  "mdf",
  "toast",
  "vcd",
  "c",
  "class",
  "cpp",
  "cs",
  "dtd",
  "fla",
  "h",
  "java",
  "lua",
  "m",
  "pl",
  "py",
  "sh",
  "sln",
  "swift",
  "vb",
  "vcxproj",
  "xcodeproj",
  "bak",
  "tmp",
  "ics",
  "msi",
  "part",
  "torrent"
];
