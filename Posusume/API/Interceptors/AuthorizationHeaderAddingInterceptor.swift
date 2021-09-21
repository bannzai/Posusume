import Foundation
import Apollo
import FirebaseAuth

public class AuthorizationHeaderAddingInterceptor: ApolloInterceptor {
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            chain.handleErrorAsync(AppError.unstableNetwork, request: request, response: response, completion: completion)
            return
        }

        currentUser.getIDToken(completion: { idToken, error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code), let appError = mapped(for: errorCode, error: error) {
                    if case .unstableNetwork = appError {
                        chain.retry(request: request, completion: completion)
                    } else {
                        chain.handleErrorAsync(appError, request: request, response: response, completion: completion)
                    }
                } else {
                    chain.handleErrorAsync(error, request: request, response: response, completion: completion)
                }
            } else if let idToken = idToken {
                request.addHeader(name: "Authorization", value: "Bearer \(idToken)")

                chain.proceedAsync(
                    request: request,
                    response: response,
                    completion: completion
                )
            } else {
                fatalError("unexpected error and idToken are nil")
            }
        })
    }
}

// NOTE: getIDToken return `FIRAuthErrors` for a list of error codes that are common to all API methods.
// See also: https://github.com/firebase/firebase-ios-sdk/blob/9b4c5c06f38680e03794184836b73817c6bc5d77/FirebaseAuth/Sources/Public/FirebaseAuth/FIRUser.h#L325-L332
// Document: https://firebase.google.cn/docs/auth/ios/errors?hl=en
private func mapped(for errorCode: AuthErrorCode, error: Error) -> AppError? {
    switch errorCode {
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
    case .invalidCustomToken,
         .customTokenMismatch,
         .invalidCredential,
         .userDisabled,
         .operationNotAllowed,
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
