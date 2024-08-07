{
  "bundleVersion" : 6256,
  "codeRequirements" : {
    "/System/Library/CoreServices/AppleIDAuthAgent" : {
      "type" : "anchorApple"
    },
    "/usr/bin/sntp" : {
      "codeIdentifier" : "com.apple.sntp",
      "type" : "anchorApple"
    },
    "/usr/libexec/airportd" : {
      "codeIdentifier" : "com.apple.airport.airportd",
      "type" : "anchorApple"
    },
    "/usr/libexec/bootpd" : {
      "codeIdentifier" : "com.apple.bootpd",
      "type" : "anchorApple"
    },
    "/usr/libexec/configd" : {
      "codeIdentifier" : "com.apple.configd",
      "type" : "anchorApple"
    },
    "/usr/libexec/syspolicyd" : {
      "codeIdentifier" : "com.apple.syspolicyd",
      "type" : "anchorApple"
    },
    "/usr/libexec/timed" : {
      "codeIdentifier" : "com.apple.timed",
      "type" : "anchorApple"
    },
    "/usr/libexec/trustd" : {
      "codeIdentifier" : "com.apple.trustd",
      "type" : "anchorApple"
    },
    "/usr/libexec/wifid" : {
      "codeIdentifier" : "com.apple.wifid",
      "type" : "anchorApple"
    },
    "/usr/sbin/mDNSResponder" : {
      "codeIdentifier" : "com.apple.mDNSResponder",
      "type" : "anchorApple"
    },
    "/usr/sbin/mDNSResponderHelper" : {
      "codeIdentifier" : "com.apple.mDNSResponderHelper",
      "type" : "anchorApple"
    },
    "/usr/sbin/ntpd" : {
      "codeIdentifier" : "com.apple.ntpd",
      "type" : "anchorApple"
    },
    "/usr/sbin/ocspd" : {
      "codeIdentifier" : "com.apple.ocspd",
      "type" : "anchorApple"
    }
  },
  "developerTeamNames" : {

  },
  "factoryRuleSetVersion" : 420,
  "globalDefaults" : {
    "activeSilentMode" : 1,
    "firstLaunchDate" : "2022-08-30T19:45:26Z",
    "monitorMaxConnectionsInModel" : 50000,
    "networkFilterEnabled" : 0,
    "primitive_automaticProfileSwitchingDistinguishOpenVPNServers" : 1
  },
  "groups" : {
    "aaaaac" : {
      "isActive" : true,
      "lastUpdateInvalidDomainsCount" : 0,
      "type" : "builtinMacOSServices"
    },
    "aaaaad" : {
      "isActive" : true,
      "lastUpdateInvalidDomainsCount" : 0,
      "type" : "builtinICloudServices"
    }
  },
  "networkTriggers" : [

  ],
  "profiles" : {

  },
  "rules" : [
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "direction" : "incoming",
      "factoryID" : 301,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "68",
      "process" : "/usr/libexec/configd",
      "protected" : true,
      "protocol" : "udp",
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "direction" : "incoming",
      "factoryHelpText" : "#en\nICMP data packets are used to propagate information relating to the network itself, e.g. whether a host is unreachable or whether a remote port is not ready to receive connections. This rule allows all system processes to receive ICMP data packets.\n#de\nICMP Datenpakete werden vorrangig für Fehlermeldungen bzw. zur Diagnose des Netzwerks oder der Netzwerkverbindungen verwendet. Zum Beispiel um herauszufinden, ob ein Computer unerreichbar ist, oder ob ein Port empfangsbereit ist. Diese Regel erlaubt allen Systemprozessen, ICMP Datenpakete zu empfangen.",
      "factoryID" : 413,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "protected" : true,
      "protocol" : "icmp",
      "remote" : "any",
      "requiresTrustedSignatureForAnyProcess" : true
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "direction" : "incoming",
      "factoryHelpText" : "#en\nICMP data packets are used to propagate information relating to the network itself, e.g. whether a host is unreachable or whether a remote port is not ready to receive connections. This rule allows all user processes to receive ICMP data packets.\n#de\nICMP Datenpakete werden vorrangig für Fehlermeldungen bzw. zur Diagnose des Netzwerks oder der Netzwerkverbindungen verwendet. Zum Beispiel um herauszufinden, ob ein Computer unerreichbar ist, oder ob ein Port empfangsbereit ist. Diese Regel erlaubt allen Benutzerprozessen, ICMP Datenpakete zu empfangen.",
      "factoryID" : 302,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "protected" : true,
      "protocol" : "icmp",
      "remote" : "any",
      "requiresTrustedSignatureForAnyProcess" : true,
      "uid" : 501
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "direction" : "incoming",
      "factoryHelpText" : "#en\nThis rule covers the localhost and zero addresses on the loopback interface",
      "factoryID" : 262,
      "hidden" : true,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "priority" : "high",
      "protected" : true,
      "remote-addresses" : "0.0.0.0, 127.0.0.1, ::0-::1"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "direction" : "incoming",
      "factoryHelpText" : "#en\nLocal Network is an alias for your home or company network. Technically speaking, it covers all networks your computer is physically connected to (e.g. via Wi-Fi, ethernet cable, dial-up connection, etc). The represented address ranges are updated with every change of your network configuration.\n#de\n„Lokales Netzwerk“ ist eine allgemeine Bezeichnung für das aktuelle Heim- oder Firmennetzwerk, mit dem dein Computer direkt verbunden ist (z.B. über WLAN, Netzwerkkabel, Modem, o.ä.). Die entsprechenden Adressbereiche werden bei jeder Änderung der Netzwerkkonfiguration deines Computers angepasst.",
      "factoryID" : 253,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "protected" : true,
      "remote" : "local-net",
      "requiresTrustedSignatureForAnyProcess" : true
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "direction" : "incoming",
      "factoryHelpText" : "#en\nLocal Network is an alias for your home or company network. Technically speaking, it covers all networks your computer is physically connected to (e.g. via Wi-Fi, ethernet cable, dial-up connection, etc). The represented address ranges are updated with every change of your network configuration.\n#de\n„Lokales Netzwerk“ ist eine allgemeine Bezeichnung für das aktuelle Heim- oder Firmennetzwerk, mit dem dein Computer direkt verbunden ist (z.B. über WLAN, Netzwerkkabel, Modem, o.ä.). Die entsprechenden Adressbereiche werden bei jeder Änderung der Netzwerkkonfiguration deines Computers angepasst.",
      "factoryID" : 253,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "protected" : true,
      "remote" : "local-net",
      "requiresTrustedSignatureForAnyProcess" : true,
      "uid" : 501
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nAppleIDAuthAgent is used to check whether Apple-ID certificates are valid.\n#de\nAppleIDAuthAgent wird verwendet, um Apple-ID Zertifikate zu überprüfen.",
      "factoryID" : 420,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "443",
      "process" : "/System/Library/CoreServices/AppleIDAuthAgent",
      "protected" : true,
      "remote-hosts" : "setup.icloud.com"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nAppleIDAuthAgent is used to check whether Apple-ID certificates are valid.\n#de\nAppleIDAuthAgent wird verwendet, um Apple-ID Zertifikate zu überprüfen.",
      "factoryID" : 420,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "ports" : "443",
      "process" : "/System/Library/CoreServices/AppleIDAuthAgent",
      "protected" : true,
      "remote-hosts" : "setup.icloud.com",
      "uid" : 501
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 404,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "123",
      "process" : "/usr/bin/sntp",
      "protected" : true,
      "protocol" : "udp",
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 417,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/libexec/airportd",
      "protected" : true,
      "remote" : "bpf"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 419,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/libexec/bootpd",
      "protected" : true,
      "remote" : "bpf"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 416,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/libexec/configd",
      "protected" : true,
      "remote" : "bpf"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 420,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "443",
      "process" : "/usr/libexec/syspolicyd",
      "protected" : true,
      "remote-hosts" : "api.apple-cloudkit.com"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 412,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "123",
      "process" : "/usr/libexec/timed",
      "protected" : true,
      "protocol" : "udp",
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 300,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/libexec/trustd",
      "protected" : true,
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 300,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "process" : "/usr/libexec/trustd",
      "protected" : true,
      "remote" : "any",
      "uid" : 501
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 419,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/libexec/wifid",
      "protected" : true,
      "remote" : "bpf"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 253,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/sbin/mDNSResponder",
      "protected" : true,
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 418,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/sbin/mDNSResponderHelper",
      "protected" : true,
      "remote" : "bpf"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 404,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "123",
      "process" : "/usr/sbin/ntpd",
      "protected" : true,
      "protocol" : "udp",
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryID" : 253,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "process" : "/usr/sbin/ocspd",
      "protected" : true,
      "remote" : "any"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nThis rule covers the localhost and zero addresses on the loopback interface",
      "factoryID" : 262,
      "hidden" : true,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "priority" : "high",
      "protected" : true,
      "remote-addresses" : "0.0.0.0, 127.0.0.1, ::0-::1"
    },
    {
      "action" : "ask",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nThis rule asks for divert connections over the loopback interface",
      "factoryID" : 262,
      "hidden" : true,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "priority" : "high",
      "protected" : true,
      "protocol" : "254",
      "remote-addresses" : "0.0.0.0, 127.0.0.1, ::0-::1"
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nThis rule enables access to services by Apple.\n#de\nDiese Regel ermöglicht den Zugriff auf Dienste von Apple.",
      "factoryID" : 404,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "protected" : true,
      "remote-domains" : [
        "apple.com",
        "cdn-apple.com",
        "mzstatic.com"
      ],
      "requiresTrustedSignatureForAnyProcess" : true
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nThis rule enables access to services by Apple.\n#de\nDiese Regel ermöglicht den Zugriff auf Dienste von Apple.",
      "factoryID" : 404,
      "group" : "aaaaac",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "protected" : true,
      "remote-domains" : [
        "apple.com",
        "cdn-apple.com",
        "mzstatic.com"
      ],
      "requiresTrustedSignatureForAnyProcess" : true,
      "uid" : 501
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nThis rule is necessary if you want to use iCloud services.\n#de\nDiese Regel ist notwendig, wenn du iCloud-Dienste verwenden möchtest.",
      "factoryID" : 420,
      "group" : "aaaaad",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "ports" : "443",
      "protected" : true,
      "remote-domains" : [
        "icloud-content.com",
        "icloud.com"
      ],
      "requiresTrustedSignatureForAnyProcess" : true
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nThis rule is necessary if you want to use iCloud services.\n#de\nDiese Regel ist notwendig, wenn du iCloud-Dienste verwenden möchtest.",
      "factoryID" : 420,
      "group" : "aaaaad",
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "ports" : "443",
      "protected" : true,
      "remote-domains" : [
        "icloud-content.com",
        "icloud.com"
      ],
      "requiresTrustedSignatureForAnyProcess" : true,
      "uid" : 501
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nLocal Network is an alias for your home or company network. Technically speaking, it covers all networks your computer is physically connected to (e.g. via Wi-Fi, ethernet cable, dial-up connection, etc). The represented address ranges are updated with every change of your network configuration.\n#de\n„Lokales Netzwerk“ ist eine allgemeine Bezeichnung für das aktuelle Heim- oder Firmennetzwerk, mit dem dein Computer direkt verbunden ist (z.B. über WLAN, Netzwerkkabel, Modem, o.ä.). Die entsprechenden Adressbereiche werden bei jeder Änderung der Netzwerkkonfiguration deines Computers angepasst.",
      "factoryID" : 253,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "owner" : "system",
      "protected" : true,
      "remote" : "local-net",
      "requiresTrustedSignatureForAnyProcess" : true
    },
    {
      "action" : "allow",
      "creationDate" : "2022-09-01T20:11:53Z",
      "factoryHelpText" : "#en\nLocal Network is an alias for your home or company network. Technically speaking, it covers all networks your computer is physically connected to (e.g. via Wi-Fi, ethernet cable, dial-up connection, etc). The represented address ranges are updated with every change of your network configuration.\n#de\n„Lokales Netzwerk“ ist eine allgemeine Bezeichnung für das aktuelle Heim- oder Firmennetzwerk, mit dem dein Computer direkt verbunden ist (z.B. über WLAN, Netzwerkkabel, Modem, o.ä.). Die entsprechenden Adressbereiche werden bei jeder Änderung der Netzwerkkonfiguration deines Computers angepasst.",
      "factoryID" : 253,
      "modificationDate" : "2022-09-01T20:11:53Z",
      "origin" : "factory",
      "protected" : true,
      "remote" : "local-net",
      "requiresTrustedSignatureForAnyProcess" : true,
      "uid" : 501
    }
  ],
  "users" : [
    {
      "defaults" : {
        "allowGlobalEditing" : 0,
        "allowGUIScripting" : 0,
        "allowPreferencesEditing" : 1,
        "allowProfileSwitching" : 1,
        "allowRuleAndProfileEditing" : 1,
        "approveRulesAutomatically" : 1,
        "autoConfirmationAction" : 1,
        "autoConfirmationDelay" : 45,
        "confirmAutomatically" : 0,
        "confirmWithReturnKey" : 1,
        "createUnapprovedRules" : 0,
        "defaultRuleLifetimeForCreatingRulesInAlert" : 0,
        "detailLevelPortAndProtocol" : 3,
        "dontShowDenyConsequencesAgain" : [

        ],
        "monitorHotKey" : "6400@46",
        "monitorHotKeyEnabled" : 1,
        "monitorMyLocationUpdateMode" : 1,
        "monitorShowLastMinutes" : 10080,
        "monitorShowMyLocationBanner" : 1,
        "monitorStatusItemClickActivation" : 0,
        "monitorUnitsBitsPerSecond" : 0,
        "pidOfLSCShowingWelcomeWindow" : 0,
        "primitive_showSilentModeInStatusItem" : 1,
        "primitive_showStatusItem" : 1,
        "respectMyPrivacy" : 1,
        "selectFullHostnameByDefault" : 0,
        "showInactivityWarning" : 1,
        "showNetworkActivityInMenubar" : 1,
        "showNumericalDataRatesInStatusItem" : 0,
        "useActiveProfileWhenCreatingRulesInAlert" : 1,
        "useColorTrafficMeters" : 1
      },
      "fullName" : "Jimmy Jain",
      "shortName" : "jimmy",
      "uid" : 501
    }
  ]
}