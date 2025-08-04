import 'dart:convert';

class AuthResponse {
    final String? accessToken;
    final int? expiresIn;
    final int? refreshExpiresIn;
    final String? refreshToken;
    final String? tokenType;
    final int? notBeforePolicy;
    final String? sessionState;
    final String? scope;
    final String? errorDescription;
    final String? error;
    

    AuthResponse({
        this.accessToken,
        this.expiresIn,
        this.refreshExpiresIn,
        this.refreshToken,
        this.tokenType,
        this.notBeforePolicy,
        this.sessionState,
        this.scope,
        this.error,
        this.errorDescription,
    });

    factory AuthResponse.fromRawJson(String str) => AuthResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        refreshExpiresIn: json["refresh_expires_in"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
        notBeforePolicy: json["not-before-policy"],
        sessionState: json["session_state"],
        scope: json["scope"],
        error: json["error"],
        errorDescription: json["error_description"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
        "refresh_expires_in": refreshExpiresIn,
        "refresh_token": refreshToken,
        "token_type": tokenType,
        "not-before-policy": notBeforePolicy,
        "session_state": sessionState,
        "scope": scope,
        "error": error,
        "error_description": errorDescription,
    };
}
