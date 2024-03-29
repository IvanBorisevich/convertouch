import 'package:convertouch/domain/constants/constants.dart';

const currencyGroup = "Currency";
const temperatureGroup = "Temperature";
const degreeCelsiusCode = "°C";
const degreeFahrenheitCode = "°F";
const degreeKelvinCode = "K";
const degreeRankineCode = "°R";
const degreeDelisleCode = "°De";
const degreeNewtonCode = "°N";
const degreeReaumurCode = "°Ré";
const degreeRomerCode = "°Rø";

const unitDataVersions = [
  unitsV1,
];

const unitsV1 = [
  {
    "groupName": "Length",
    "units": [
      {"code": "mm", "name": "Millimeter", "coefficient": 0.001},
      {"code": "cm", "name": "Centimeter", "coefficient": 0.01},
      {"code": "dm", "name": "Decimeter", "coefficient": 0.1},
      {"code": "m", "name": "Meter", "coefficient": 1},
      {"code": "km", "name": "Kilometer", "coefficient": 1000},
      {"code": "ft", "name": "Foot", "coefficient": 0.3048, "symbol": "'"},
      {"code": "in", "name": "Inch", "coefficient": 25.4E-3, "symbol": "\""},
      {"code": "yd", "name": "Yard", "coefficient": 0.9144},
      {"code": "mi", "name": "Mile", "coefficient": 1609.34},
      {"code": "pc", "name": "Parsec", "coefficient": 3.086e+16},
      {"code": "ly", "name": "Light Year", "coefficient": 9.46e+15}
    ]
  },
  {
    "groupName": "Area",
    "units": [
      {"code": "mm²", "name": "Square Millimeter", "coefficient": 1E-6},
      {"code": "cm²", "name": "Square Centimeter", "coefficient": 1E-4},
      {"code": "dm²", "name": "Square Decimeter", "coefficient": 0.01},
      {"code": "m²", "name": "Square Meter", "coefficient": 1}
    ]
  },
  {
    "groupName": "Volume",
    "units": [
      {"code": "mm³", "name": "Cubic Millimeter", "coefficient": 1E-9},
      {"code": "cm", "name": "Cubic Centimeter", "coefficient": 1E-6},
      {"code": "dm³", "name": "Cubic Decimeter (Liter)", "coefficient": 1E-3},
      {"code": "m³", "name": "Cubic Meter", "coefficient": 1},
      {"code": "gal", "name": "Gallon USA", "coefficient": 3.785411784E-3},
      {"code": "bbls", "name": "Oil Barrel", "coefficient": 158.987E-3}
    ]
  },
  {
    "groupName": "Mass",
    "units": [
      {"code": "g", "name": "Gram", "coefficient": 0.001},
      {"code": "kg", "name": "Kilogram", "coefficient": 1},
      {"code": "T", "name": "Ton", "coefficient": 1000},
      {"code": "lb.", "name": "English Pound", "coefficient": 0.45359237},
      {"code": "oz.", "name": "Ounce", "coefficient": 0.028349523},
      {"code": "ct", "name": "Carat", "coefficient": 0.0002}
    ]
  },
  {
    "groupName": temperatureGroup,
    "conversionType": ConversionType.formula,
    "refreshable": true,
    "units": [
      {"code": degreeCelsiusCode, "name": "Degree Celsius"},
      {"code": degreeFahrenheitCode, "name": "Degree Fahrenheit"},
      {"code": degreeKelvinCode, "name": "Degree Kelvin"},
      {"code": degreeRankineCode, "name": "Degree Rankine"},
      {"code": degreeDelisleCode, "name": "Degree Delisle"},
      {"code": degreeNewtonCode, "name": "Degree Newton"},
      {"code": degreeReaumurCode, "name": "Degree Réaumur"},
      {"code": degreeRomerCode, "name": "Degree Rømer"},
    ]
  },
  {
    "groupName": currencyGroup,
    "conversionType": ConversionType.dynamic,
    "refreshable": true,
    "units": [
      {"code": "USD", "name": "Dollar USA", "coefficient": 1, "symbol": "\$"},
      {
        "code": "AUD",
        "name": "Australian Dollar",
        "coefficient": 0.65478373881633,
        "symbol": "A\$",
      },
      {
        "code": "CAD",
        "name": "Canadian Dollar",
        "coefficient": 0.74045868249985,
        "symbol": "C\$",
      },
      {
        "code": "CNY",
        "name": "Chinese Yuan",
        "coefficient": 0.13891793873825,
        "symbol": "元",
      },
      {
        "code": "EUR",
        "name": "Euro",
        "coefficient": 1.0853015986635,
        "symbol": "€"
      },
      {
        "code": "GBP",
        "name": "U.K. Pound Sterling",
        "coefficient": 1.2683585750407,
        "symbol": "£",
      },
      {
        "code": "HKD",
        "name": "Hong Kong Dollar",
        "coefficient": 0.12780679794563,
        "symbol": "元",
      },
      {
        "code": "IDR",
        "name": "Indonesian Rupiah",
        "coefficient": 0.000063821108092331,
        "symbol": "Rp",
      },
      {
        "code": "INR",
        "name": "Indian Rupee",
        "coefficient": 0.012064420491973,
        "symbol": "₹",
      },
      {
        "code": "JPY",
        "name": "Japanese Yen",
        "coefficient": 0.0066526755987381,
        "symbol": "¥",
      },
      {
        "code": "KRW",
        "name": "South Korean Won",
        "coefficient": 0.00075100092425432,
        "symbol": "₩",
      },
      {
        "code": "MYR",
        "name": "Malaysian Ringgit",
        "coefficient": 0.20957711965191,
        "symbol": "RM",
      },
      {
        "code": "NZD",
        "name": "New Zealand Dollar",
        "coefficient": 0.61663134764186,
        "symbol": "\$NZ",
      },
      {
        "code": "PHP",
        "name": "Philippine Peso",
        "coefficient": 0.017839031276498,
        "symbol": "₱",
      },
      {
        "code": "SGD",
        "name": "Singapore Dollar",
        "coefficient": 0.74416291008776,
        "symbol": "S\$",
      },
      {
        "code": "THB",
        "name": "Thai Baht",
        "coefficient": 0.027856620813799,
        "symbol": "฿",
      },
      {
        "code": "TWD",
        "name": "New Taiwan Dollar",
        "coefficient": 0.031624504292983,
        "symbol": "元",
      },
      {
        "code": "VND",
        "name": "Vietnamese Dong",
        "coefficient": 0.000040559217298525,
        "symbol": "Đ",
      },
      {
        "code": "CHF",
        "name": "Swiss Franc",
        "coefficient": 1.1371000132971,
        "symbol": "SFr",
      },
      {
        "code": "DKK",
        "name": "Danish Krone",
        "coefficient": 0.14561480900149,
        "symbol": "DKr",
      },
      {
        "code": "NGN",
        "name": "Nigerian Naira",
        "coefficient": 0.00060155803531146,
        "symbol": "₦",
      },
      {
        "code": "SAR",
        "name": "Saudi Riyal",
        "coefficient": 0.2663358652955,
        "symbol": "SR",
      },
      {
        "code": "XAF",
        "name": "Central African CFA Franc",
        "coefficient": 0.0016539716187299,
        "symbol": "fr.CFA",
      },
      {
        "code": "XOF",
        "name": "West African CFA Franc",
        "coefficient": 0.0016539716187299,
        "symbol": "fr.CFA",
      },
      {
        "code": "ZAR",
        "name": "South African Rand",
        "coefficient": 0.052303529249381,
        "symbol": "R",
      },
      {
        "code": "BGN",
        "name": "Bulgarian Lev",
        "coefficient": 0.55505327123834,
        "symbol": "lev",
      },
      {
        "code": "BRL",
        "name": "Brazilian Real",
        "coefficient": 0.20156381441144,
        "symbol": "R\$",
      },
      {
        "code": "CLP",
        "name": "Chilean Peso",
        "coefficient": 0.0010123092075134,
        "symbol": "Ch\$",
      },
      {
        "code": "CZK",
        "name": "Czech Crown",
        "coefficient": 0.042855429559951,
        "symbol": "Kč",
      },
      {
        "code": "HUF",
        "name": "Hungarian Forint",
        "coefficient": 0.0027828724926791,
        "symbol": "Ft",
      },
      {
        "code": "ILS",
        "name": "Israeli New Sheqel",
        "coefficient": 0.27588564705249,
        "symbol": "₪",
      },
      {
        "code": "ISK",
        "name": "Icelandic Krona",
        "coefficient": 0.0072713024640462,
        "symbol": "IKr",
      },
      {
        "code": "MXN",
        "name": "Mexican Peso",
        "coefficient": 0.058607078439524,
        "symbol": "Mex\$",
      },
      {
        "code": "NOK",
        "name": "Norwegian Krone",
        "coefficient": 0.094939520651187,
        "symbol": "kr",
      },
      {
        "code": "PLN",
        "name": "Polish Zloty",
        "coefficient": 0.25159154141186,
        "symbol": "zł",
      },
      {
        "code": "RON",
        "name": "Romanian New Leu",
        "coefficient": 0.21855974070038,
        "symbol": "leu",
      },
      {
        "code": "SEK",
        "name": "Swedish Krona",
        "coefficient": 0.097072056633032,
        "symbol": "SKr",
      },
      {
        "code": "TRY",
        "name": "Turkish Lira",
        "coefficient": 0.032103731543513,
        "symbol": "₺",
      },
      {
        "code": "UAH",
        "name": "Ukrainian Hryvnia",
        "coefficient": 0.026022085660053,
        "symbol": "₴",
      },
      {
        "code": "AED",
        "name": "U.A.E Dirham",
        "coefficient": 0.26932046192879,
        "symbol": "Dh",
      },
      {
        "code": "EGP",
        "name": "Egyptian Pound",
        "coefficient": 0.032363951857894,
        "symbol": "LE",
      },
      {
        "code": "MDL",
        "name": "Moldovan Leu",
        "coefficient": 0.05603532201111,
        "symbol": "leu",
      },
      {
        "code": "RSD",
        "name": "Serbian Dinar",
        "coefficient": 0.0091488590745835,
        "symbol": "DIN",
      },
      {
        "code": "RUB",
        "name": "Russian Rouble",
        "coefficient": 0.010857955600569,
        "symbol": "₽",
      },
      {
        "code": "AMD",
        "name": "Armenia Dram",
        "coefficient": 0.0024215027234943,
        "symbol": "֏",
      },
      {
        "code": "AZN",
        "name": "Azerbaijan Manat",
        "coefficient": 0.58858188310183,
        "symbol": "₼",
      },
      {
        "code": "BDT",
        "name": "Bangladeshi taka",
        "coefficient": 0.008995906289078,
        "symbol": "৳",
      },
      {
        "code": "DOP",
        "name": "Dominican Peso",
        "coefficient": 0.016739613229316,
        "symbol": "RD\$",
      },
      {
        "code": "DZD",
        "name": "Algerian Dinar",
        "coefficient": 0.0072794901193704,
        "symbol": "DA",
      },
      {
        "code": "GEL",
        "name": "Georgian lari",
        "coefficient": 0.36496646705651,
        "symbol": "₾",
      },
      {
        "code": "IQD",
        "name": "Iraqi dinar",
        "coefficient": 0.0007462348633308,
        "symbol": "ID",
      },
      {
        "code": "IRR",
        "name": "Iranian rial",
        "coefficient": 0.00002327527202413,
        "symbol": "IR",
      },
      {
        "code": "KGS",
        "name": "Kyrgyzstan Som",
        "coefficient": 0.010944465698024,
        "symbol": "⃀",
      },
      {
        "code": "KZT",
        "name": "Kazakhstani Tenge",
        "coefficient": 0.0022220747484053,
        "symbol": "₸",
      },
      {
        "code": "LYD",
        "name": "Libyan Dinar",
        "coefficient": 0.20247287566135,
        "symbol": "LD",
      },
      {
        "code": "MAD",
        "name": "Moroccan Dirham",
        "coefficient": 0.097598172018664,
        "symbol": "DH",
      },
      {
        "code": "PKR",
        "name": "Pakistani Rupee",
        "coefficient": 0.0035545819276229,
        "symbol": "PRe",
      },
      {
        "code": "TJS",
        "name": "Tajikistan Somoni",
        "coefficient": 0.08920777933059,
        "symbol": "SM",
      },
      {
        "code": "TMT",
        "name": "New Turkmenistan Manat",
        "coefficient": 0.27930326428956,
        "symbol": "m",
      },
      {
        "code": "TND",
        "name": "Tunisian Dinar",
        "coefficient": 0.31427180549571,
        "symbol": "DT",
      },
      {
        "code": "UZS",
        "name": "Uzbekistan Sum",
        "coefficient": 0.000078706776074889
      },
      {
        "code": "BYN",
        "name": "Belarusian Ruble",
        "coefficient": 0.30556426109006,
        "symbol": "R",
      },
      {
        "code": "PEN",
        "name": "Peruvian Nuevo Sol",
        "coefficient": 0.26388646933425,
        "symbol": "S/",
      },
      {
        "code": "ARS",
        "name": "Argentine Peso",
        "coefficient": 0.0011895043731779,
        "symbol": "Arg\$",
      },
      {
        "code": "BOB",
        "name": "Bolivian Boliviano",
        "coefficient": 0.14577259475219,
        "symbol": "Bs"
      },
      {
        "code": "COP",
        "name": "Colombian Peso",
        "coefficient": 0.00025364431486881,
        "symbol": "Col\$",
      },
      {
        "code": "CRC",
        "name": "Costa Rican Colón",
        "coefficient": 0.0019410230366233,
        "symbol": "₡",
      },
      {
        "code": "HTG",
        "name": "Haitian gourde",
        "coefficient": 0.0075991253644315,
        "symbol": "G",
      },
      {
        "code": "PAB",
        "name": "Panamanian Balboa",
        "coefficient": 1,
        "symbol": "B/"
      },
      {
        "code": "PYG",
        "name": "Paraguayan Guarani",
        "coefficient": 0.00013702623906706,
        "symbol": "₲",
      },
      {
        "code": "UYU",
        "name": "Uruguayan Peso",
        "coefficient": 0.025555393586006,
        "symbol": "\$U",
      },
      {
        "code": "VES",
        "name": "Venezuelan Bolivar",
        "coefficient": 0.027628279883382,
        "symbol": "Bs"
      },
      {
        "code": "JOD",
        "name": "Jordanian Dinar",
        "coefficient": 1.4102493833927,
        "symbol": "JD",
      },
      {
        "code": "LBP",
        "name": "Lebanese Pound",
        "coefficient": 0.000010961907371883,
        "symbol": "LL",
      },
      {
        "code": "AFN",
        "name": "Afghan afghani",
        "coefficient": 0.013562528148926,
        "symbol": "Af",
      },
      {
        "code": "MGA",
        "name": "Malagasy ariary",
        "coefficient": 0.00022018715908523,
        "symbol": "Ar",
      },
      {
        "code": "ETB",
        "name": "Ethiopian birr",
        "coefficient": 0.017639993994895,
        "symbol": "Br",
      },
      {
        "code": "SVC",
        "name": "Salvadoran colon",
        "coefficient": 0.11424711004353,
        "symbol": "₡",
      },
      {
        "code": "NIO",
        "name": "Nicaraguan Córdoba",
        "coefficient": 0.027173097132562,
        "symbol": "C\$",
      },
      {
        "code": "GMD",
        "name": "Gambian dalasi",
        "coefficient": 0.014737526897863,
        "symbol": "D",
      },
      {
        "code": "MKD",
        "name": "Macedonian denar",
        "coefficient": 0.017526647650502,
        "symbol": "DEN",
      },
      {
        "code": "BHD",
        "name": "Bahrain Dinar",
        "coefficient": 2.6529049692238,
        "symbol": "BD",
      },
      {
        "code": "KWD",
        "name": "Kuwaiti Dinar",
        "coefficient": 3.2500625531702,
        "symbol": "KD",
      },
      {
        "code": "STN",
        "name": "São Tomé and Príncipe Dobra",
        "coefficient": 0.043637091527799,
        "symbol": "Db",
      },
      {
        "code": "BSD",
        "name": "Bahamian Dollar",
        "coefficient": 1,
        "symbol": "B\$",
      },
      {
        "code": "BBD",
        "name": "Barbadian Dollar",
        "coefficient": 0.49532102286944,
        "symbol": "Bds\$",
      },
      {
        "code": "BZD",
        "name": "Belize dollar",
        "coefficient": 0.496146724716,
        "symbol": "BZ\$",
      },
      {
        "code": "BND",
        "name": "Brunei Dollar",
        "coefficient": 0.74403242756341,
      },
      {
        "code": "FJD",
        "name": "Fiji Dollar",
        "coefficient": 0.4420007005955,
        "symbol": "B\$",
      },
      {
        "code": "GYD",
        "name": "Guyanese dollar",
        "coefficient": 0.0047763098633839,
        "symbol": "G\$",
      },
      {
        "code": "JMD",
        "name": "Jamaican Dollar",
        "coefficient": 0.0063804233598558,
        "symbol": "J\$",
      },
      {
        "code": "LRD",
        "name": "Liberian dollar",
        "coefficient": 0.0051794024921183,
        "symbol": "L\$",
      },
      {
        "code": "NAD",
        "name": "Namibian dollar",
        "coefficient": 0.052894960716608
      },
      {
        "code": "SRD",
        "name": "Surinamese dollar",
        "coefficient": 0.027623479957964
      },
      {
        "code": "TTD",
        "name": "Trinidad Tobago Dollar",
        "coefficient": 0.1473002051744
      },
      {
        "code": "XCD",
        "name": "East Caribbean Dollar",
        "coefficient": 0.36858830005504
      },
      {
        "code": "SBD",
        "name": "Solomon Islands dollar",
        "coefficient": 0.11732472601711
      },
      {
        "code": "CVE",
        "name": "Cape Verde escudo",
        "coefficient": 0.0097582945503676
      },
      {
        "code": "AWG",
        "name": "Aruban florin",
        "coefficient": 0.5525696842316,
        "symbol": "ƒ",
      },
      {
        "code": "BIF",
        "name": "Burundian franc",
        "coefficient": 0.00035004754040934
      },
      {
        "code": "XPF",
        "name": "CFP Franc",
        "coefficient": 0.0090604513836759,
      },
      {
        "code": "DJF",
        "name": "Djiboutian franc",
        "coefficient": 0.005616023620077
      },
      {
        "code": "GNF",
        "name": "Guinean franc",
        "coefficient": 0.00011634889656208
      },
      {
        "code": "KMF",
        "name": "\tComoro franc",
        "coefficient": 0.0021918630836211
      },
      {
        "code": "CDF",
        "name": "Congolese franc",
        "coefficient": 0.0003623079617675
      },
      {
        "code": "RWF",
        "name": "Rwandan franc",
        "coefficient": 0.00078441675424109
      },
      {
        "code": "GIP",
        "name": "Gibraltar pound",
        "coefficient": 1.2612220387329
      },
      {
        "code": "SSP",
        "name": "South Sudanese pound",
        "coefficient": 0.00077816143722163
      },
      {
        "code": "SDG",
        "name": "Sudanese pound",
        "coefficient": 0.0016654156032628
      },
      {
        "code": "SYP",
        "name": "Syrian pound",
        "coefficient": 0.000076815292999049
      },
      {
        "code": "GHS",
        "name": "Ghanaian Cedi",
        "coefficient": 0.080018015313017,
        "symbol": "₵",
      },
      {
        "code": "ANG",
        "name": "Neth. Antillean Guilder",
        "coefficient": 0.55492168343091,
        "symbol": "ƒ",
      },
      {
        "code": "PGK",
        "name": "Papua New Guinean kina",
        "coefficient": 0.26262322974528
      },
      {
        "code": "LAK",
        "name": "Lao kip",
        "coefficient": 0.000048040834709503,
        "symbol": "₭",
      },
      {
        "code": "MWK",
        "name": "Malawian kwacha",
        "coefficient": 0.00059400490416854
      },
      {
        "code": "ZMW",
        "name": "Zambian kwacha",
        "coefficient": 0.044212580693589
      },
      {
        "code": "AOA",
        "name": "Angolan kwanza",
        "coefficient": 0.0011765000250213
      },
      {
        "code": "MMK",
        "name": "Myanma Kyat",
        "coefficient": 0.00047615473152179
      },
      {
        "code": "ALL",
        "name": "Albanian lek",
        "coefficient": 0.010420607516389,
      },
      {
        "code": "HNL",
        "name": "Honduran Lempira",
        "coefficient": 0.040509433018065
      },
      {
        "code": "SZL",
        "name": "Swazi lilangeni",
        "coefficient": 0.052894960716608
      },
      {
        "code": "LSL",
        "name": "Lesotho loti",
        "coefficient": 0.052894960716608,
      },
      {
        "code": "MZN",
        "name": "Mozambican metical",
        "coefficient": 0.015663313816744
      },
      {
        "code": "ERN",
        "name": "Eritrean nakfa",
        "coefficient": 0.066331381674423
      },
      {
        "code": "MRU",
        "name": "Mauritanian ouguiya",
        "coefficient": 0.025221438222489,
        "symbol": "UM",
      },
      {
        "code": "TOP",
        "name": "Tongan paʻanga",
        "coefficient": 0.42941500275234,
        "symbol": "T\$",
      },
      {
        "code": "MOP",
        "name": "Macanese pataca",
        "coefficient": 0.12405544713006
      },
      {
        "code": "CUP",
        "name": "Cuban peso",
        "coefficient": 1,
        "symbol": "Cu\$",
      },
      {
        "code": "BWP",
        "name": "Botswana Pula",
        "coefficient": 0.073062102787368
      },
      {
        "code": "GTQ",
        "name": "Guatemalan Quetzal",
        "coefficient": 0.12820897763098,
        "symbol": "Q",
      },
      {
        "code": "YER",
        "name": "Yemeni rial",
        "coefficient": 0.0039968973627583,
      },
      {
        "code": "QAR",
        "name": "Qatari Rial",
        "coefficient": 0.27423309813341,
        "symbol": "QR",
      },
      {
        "code": "OMR",
        "name": "Omani Rial",
        "coefficient": 2.5976329880398,
        "symbol": "RO",
      },
      {
        "code": "KHR",
        "name": "Cambodian riel",
        "coefficient": 0.00024545863984385
      },
      {
        "code": "LKR",
        "name": "Sri Lanka Rupee",
        "coefficient": 0.0032092278436671
      },
      {
        "code": "MVR",
        "name": "Maldivian rufiyaa",
        "coefficient": 0.064679977981284,
        "symbol": "Rf",
      },
      {
        "code": "MUR",
        "name": "Mauritian Rupee",
        "coefficient": 0.021843567031977
      },
      {
        "code": "NPR",
        "name": "Nepalese Rupee",
        "coefficient": 0.0075354050943302,
        "symbol": "रू",
      },
      {
        "code": "SCR",
        "name": "Seychelles rupee",
        "coefficient": 0.074238102387029
      },
      {
        "code": "KES",
        "name": "Kenyan shilling",
        "coefficient": 0.0068498223489966
      },
      {
        "code": "SOS",
        "name": "Somali shilling",
        "coefficient": 0.001749987489366
      },
      {
        "code": "TZS",
        "name": "Tanzanian shilling",
        "coefficient": 0.00039383475954561
      },
      {
        "code": "UGX",
        "name": "Ugandan shilling",
        "coefficient": 0.00025721863584046
      },
      {
        "code": "WST",
        "name": "Samoan tala",
        "coefficient": 0.36486013111144,
        "symbol": "WS\$",
      },
      {
        "code": "MNT",
        "name": "Mongolian togrog",
        "coefficient": 0.00029324926187259,
        "symbol": "₮",
      },
      {
        "code": "VUV",
        "name": "Vanuatu vatu",
        "coefficient": 0.0082505129359956,
        "symbol": "VT",
      },
      {
        "code": "BAM",
        "name": "Bosnia and Herzegovina convertible mark",
        "coefficient": 0.55076815292998
      },
    ]
  },
  {
    "groupName": "Pressure",
    "units": [
      {"code": "Pa", "name": "pascal", "coefficient": 1},
      {"code": "bar", "name": "bar", "coefficient": 100000},
      {"code": "at", "name": "technical atmosphere", "coefficient": 98066.5},
      {"code": "atm", "name": "physical atmosphere", "coefficient": 101325},
      {"code": "mmHg", "name": "millimetre of mercury", "coefficient": 133.322},
      {"code": "mmH2O", "name": "millimetre of water", "coefficient": 9.807},
      {"code": "psi", "name": "pound per square inch", "coefficient": 6894.757},
      {"code": "Ba", "name": "barye", "coefficient": 0.1},
      {"code": "pz", "name": "pièze", "coefficient": 1000},
    ]
  },
];
