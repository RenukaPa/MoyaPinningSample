/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Moya
import Alamofire
import TrustKit


//// 1 - provider creation
//let provider = MoyaProvider<MyRouter>(
//    manager: AlamofireSessionManagerBuilder().build()
//)

// 2 - session manager builder
class MoyaPinningSessionMnager {
    
  // 5 - session manager creator
  func build() -> Manager {
    let manager = Manager(configuration: URLSessionConfiguration.default,delegate:SessionDelegateExt(),
                          serverTrustPolicyManager: nil)
    manager.startRequestsImmediately = false
    return manager
  }
}

// MARK: - URLSessionDelegate
class SessionDelegateExt: SessionDelegate {
}

extension SessionDelegateExt {
  
  open override func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
  {
    // Call into TrustKit here to do pinning validation
    if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
      // TrustKit did not handle this challenge: perhaps it was not for server trust
      // or the domain was not pinned. Fall back to the default behavior
      completionHandler(.performDefaultHandling, nil)
    }
    else{
      
      print("Passed pin validation.")
    }
  }
}

// MARK: - URLSessionTaskDelegate

extension SessionDelegateExt {
  /// Tells the delegate that the remote server requested an HTTP redirect.
  ///
  /// - parameter session:           The session containing the task whose request resulted in a redirect.
  /// - parameter task:              The task whose request resulted in a redirect.
  /// - parameter response:          An object containing the server’s response to the original request.
  /// - parameter request:           A URL request object filled out with the new location.
  /// - parameter completionHandler: A closure that your handler should call with either the value of the request
  ///                                parameter, a modified URL request object, or NULL to refuse the redirect and
  ///                                return the body of the redirect response.
  
  
  /// Requests credentials from the delegate in response to an authentication request from the remote server.
  ///
  /// - parameter session:           The session containing the task whose request requires authentication.
  /// - parameter task:              The task whose request requires authentication.
  /// - parameter challenge:         An object that contains the request for authentication.
  /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
  ///                                and credential.
  open override func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
  {
    // Call into TrustKit here to do pinning validation
    if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
      // TrustKit did not handle this challenge: perhaps it was not for server trust
      // or the domain was not pinned. Fall back to the default behavior
      completionHandler(.performDefaultHandling, nil)
    }
    else{
      
      print("Passed pin validation.")
    }
  }
}
