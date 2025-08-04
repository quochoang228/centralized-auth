import 'dart:convert';

class UserCentralized {
    final int? exp;
    final int? iat;
    final String? jti;
    final String? iss;
    final String? aud;
    final String? sub;
    final String? typ;
    final String? azp;
    final String? sid;
    final String? acr;
    final List<String>? allowedOrigins;
    final RealmAccess? realmAccess;
    final ResourceAccess? resourceAccess;
    final String? scope;
    final bool? emailVerified;
    final String? name;
    final String? preferredUsername;
    final String? givenName;
    final String? familyName;
    final String? email;

    UserCentralized({
        this.exp,
        this.iat,
        this.jti,
        this.iss,
        this.aud,
        this.sub,
        this.typ,
        this.azp,
        this.sid,
        this.acr,
        this.allowedOrigins,
        this.realmAccess,
        this.resourceAccess,
        this.scope,
        this.emailVerified,
        this.name,
        this.preferredUsername,
        this.givenName,
        this.familyName,
        this.email,
    });

    factory UserCentralized.fromRawJson(String str) => UserCentralized.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserCentralized.fromJson(Map<String, dynamic> json) => UserCentralized(
        exp: json["exp"],
        iat: json["iat"],
        jti: json["jti"],
        iss: json["iss"],
        aud: json["aud"],
        sub: json["sub"],
        typ: json["typ"],
        azp: json["azp"],
        sid: json["sid"],
        acr: json["acr"],
        allowedOrigins: json["allowed-origins"] == null ? [] : List<String>.from(json["allowed-origins"]!.map((x) => x)),
        realmAccess: json["realm_access"] == null ? null : RealmAccess.fromJson(json["realm_access"]),
        resourceAccess: json["resource_access"] == null ? null : ResourceAccess.fromJson(json["resource_access"]),
        scope: json["scope"],
        emailVerified: json["email_verified"],
        name: json["name"],
        preferredUsername: json["preferred_username"],
        givenName: json["given_name"],
        familyName: json["family_name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "exp": exp,
        "iat": iat,
        "jti": jti,
        "iss": iss,
        "aud": aud,
        "sub": sub,
        "typ": typ,
        "azp": azp,
        "sid": sid,
        "acr": acr,
        "allowed-origins": allowedOrigins == null ? [] : List<dynamic>.from(allowedOrigins!.map((x) => x)),
        "realm_access": realmAccess?.toJson(),
        "resource_access": resourceAccess?.toJson(),
        "scope": scope,
        "email_verified": emailVerified,
        "name": name,
        "preferred_username": preferredUsername,
        "given_name": givenName,
        "family_name": familyName,
        "email": email,
    };
}

class RealmAccess {
    final List<String>? roles;

    RealmAccess({
        this.roles,
    });

    factory RealmAccess.fromRawJson(String str) => RealmAccess.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RealmAccess.fromJson(Map<String, dynamic> json) => RealmAccess(
        roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    };
}

class ResourceAccess {
    final RealmAccess? account;

    ResourceAccess({
        this.account,
    });

    factory ResourceAccess.fromRawJson(String str) => ResourceAccess.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResourceAccess.fromJson(Map<String, dynamic> json) => ResourceAccess(
        account: json["account"] == null ? null : RealmAccess.fromJson(json["account"]),
    );

    Map<String, dynamic> toJson() => {
        "account": account?.toJson(),
    };
}
