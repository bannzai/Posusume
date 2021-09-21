import Foundation
import FirebaseAuth

public func mappedAppError(from error: Error) -> AppError {
    if let errorCode = AuthErrorCode(rawValue: error._code),
       let appError = mappedAppError(for: errorCode, underlyingError: error) {
        return appError
    }
    return .unexpected(error: error)
}

// Document: https://firebase.google.cn/docs/auth/ios/errors?hl=en
public func mappedAppError(for errorCode: AuthErrorCode, underlyingError error: Error) -> AppError? {
    switch errorCode {
    // Common Error Code
    // https://firebase.google.cn/docs/auth/ios/errors?hl=en#error_codes_common_to_all_api_methods
    case .appNotAuthorized:
        return .requireLogin
    case .tooManyRequests:
        return .unstableNetwork
    case .userNotFound:
        return .userDeleted
    case .networkError:
        return .unstableNetwork
    case .userTokenExpired:
        return .requireLogin
    case .invalidAPIKey:
        return .fatal
    case .keychainError, .internalError:
        return .support(error: error, code: error._code, domain: error._domain, userInfo: (error as NSError).userInfo)
    // SignIn Anonymously Error
    // https://firebase.google.cn/docs/auth/ios/errors?hl=en#signinanonymouslywithcompletion
    case .operationNotAllowed:
        return .fatal
    case .invalidCustomToken,
         .customTokenMismatch,
         .invalidCredential,
         .userDisabled,
         .emailAlreadyInUse,
         .invalidEmail,
         .wrongPassword,
         .accountExistsWithDifferentCredential,
         .requiresRecentLogin,
         .providerAlreadyLinked,
         .noSuchProvider,
         .invalidUserToken,
         .userMismatch,
         .credentialAlreadyInUse,
         .weakPassword,
         .expiredActionCode,
         .invalidActionCode,
         .invalidMessagePayload,
         .invalidSender,
         .invalidRecipientEmail,
         .missingEmail,
         .missingIosBundleID,
         .missingAndroidPackageName,
         .unauthorizedDomain,
         .invalidContinueURI,
         .missingContinueURI,
         .missingPhoneNumber,
         .invalidPhoneNumber,
         .missingVerificationCode,
         .invalidVerificationCode,
         .missingVerificationID,
         .invalidVerificationID,
         .missingAppCredential,
         .invalidAppCredential,
         .sessionExpired,
         .quotaExceeded,
         .missingAppToken,
         .notificationNotForwarded,
         .appNotVerified,
         .captchaCheckFailed,
         .webContextAlreadyPresented,
         .webContextCancelled,
         .appVerificationUserInteractionFailure,
         .invalidClientID,
         .webNetworkRequestFailed,
         .webInternalError,
         .webSignInUserInteractionFailure,
         .localPlayerNotAuthenticated,
         .nullUser,
         .dynamicLinkNotActivated,
         .invalidProviderID,
         .tenantIDMismatch,
         .unsupportedTenantOperation,
         .invalidDynamicLinkDomain,
         .rejectedCredential,
         .gameKitNotLinked,
         .secondFactorRequired,
         .missingMultiFactorSession,
         .missingMultiFactorInfo,
         .invalidMultiFactorSession,
         .multiFactorInfoNotFound,
         .adminRestrictedOperation,
         .unverifiedEmail,
         .secondFactorAlreadyEnrolled,
         .maximumSecondFactorCountExceeded,
         .unsupportedFirstFactor,
         .emailChangeNeedsVerification,
         .missingOrInvalidNonce,
         .missingClientIdentifier,
         .malformedJWT:
        return nil
    @unknown default:
        return nil
    }
}
