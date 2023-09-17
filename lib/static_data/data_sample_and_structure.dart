/// data structure
/*
  [
    {
      courseName: string,
      sections: [
        {
            sectionName: string,
            sectionContent: [
              {
                  fileName: string,
                  fileType: string,
                  fileLink: string,
              },
            ]
        },

      ]
    }
  ]
*/

/// data sample for test
List data = [
  {
    "courseName": "أمن البرمجيات",
    "sections": [
      {
        "sectionName": "Week 1",
        "sectionContent": [
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=309179", "fileType": "pdf", "fileName": "Syllabus"},
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=309181", "fileType": "pdf", "fileName": "CH0"},
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=309180", "fileType": "pdf", "fileName": "CH01"}
        ]
      },
      {"sectionName": "Week 2"},
      {"sectionName": "Week 3"},
      {"sectionName": "Week 4"}
    ]
  },
  {
    "courseName": "بحث تخرج | د. معتز سعد",
    "sections": [
      {
        "sectionName": "عام",
        "sectionContent": [
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/forum/view.php?id=67879", "fileType": "icon", "fileName": "اعلانات"},
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=308464", "fileType": "document", "fileName": "Graduation Research (CSCI4108) syllabus 2023"}
        ]
      }
    ]
  },
  {
    "courseName": "دراسات فلسطينية (عام)",
    "sections": [
      {"sectionName": "عام"},
      {"sectionName": "الإعلانات"},
      {
        "sectionName": "توصيف المساق",
        "sectionContent": [
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=272193", "fileType": "document", "fileName": "وصف مساق دراسات فلسطينية"}
        ]
      },
      {
        "sectionName": "ملفات مهمة",
        "sectionContent": [
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=307093", "fileType": "pdf", "fileName": "درسات فلسطينية 2"},
          {"fileLink": "https://moodle.iugaza.edu.ps/mod/resource/view.php?id=307094", "fileType": "pdf", "fileName": "فلسطين-الأرض-والإنسان-والتاريخ-1"}
        ]
      }
    ]
  },
  {
    "courseName": "مواضيع خاصة في الويب (2) | م. محمد أحمد الأغا",
    "sections": [
      {"sectionName": "Topic 1"},
      {"sectionName": "Topic 2"},
      {"sectionName": "Topic 3"},
      {"sectionName": "Topic 4"}
    ]
  }
];
