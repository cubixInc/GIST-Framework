//
//  HTTPServiceManager.swift
//  HttpReq
//
//  Created by Shoaib Abdul on 17/09/2016.
//  Copyright © 2016 Cubix Labs. All rights reserved.
//

import UIKit
import Alamofire

public let USER_ID = HTTPServiceManager.sharedInstance.userIdKey;

open class HTTPServiceManager: NSObject {
    
    public static let sharedInstance = HTTPServiceManager();
    
    fileprivate var _requests:[HTTPRequest] = []; // Here Hash map is not used because service name was used as key and same service may be called more than once with differen params.
    
    fileprivate var _headers:HTTPHeaders = HTTPHeaders();
    
    fileprivate var _authHeader:AuthHeader? = nil;
    
    fileprivate var _serverBaseURL:URL!;
    open class var serverBaseURL:URL {
        get {
            return self.sharedInstance._serverBaseURL;
        }
        
        set {
            self.sharedInstance._serverBaseURL = newValue;
        }
    } //P.E.
    
    public var entityFramework:Bool = false {
        didSet {
            if (entityFramework == true) {
                userIdKey = "entity_id";
                authenticationModule = "entity_auth"
            } else if (microService == true) {
                userIdKey = "NOT_DEFINED";
                authenticationModule = "user"
            } else {
                userIdKey = "user_id";
                authenticationModule = "users"
            }
        }
    } //P.E.
    
    public var microService:Bool = false {
        didSet {
            if (microService == true) {
                userIdKey = "NOT_DEFINED";
                authenticationModule = "user"
            } else if (entityFramework == true) {
                userIdKey = "entity_id";
                authenticationModule = "entity_auth"
            } else {
                userIdKey = "user_id";
                authenticationModule = "users"
            }
        }
    } //P.E.
    
    internal var userIdKey:String = "entity_id";
    internal var authenticationModule:String = "entity_auth";
    
    fileprivate var _hudRetainCount:Int = 0;
    
    fileprivate var _showProgressBlock:(()->Void)?
    fileprivate var _hideProgressBlock:(()->Void)?
    
    fileprivate var _failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?
    fileprivate var _invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?
    fileprivate var _noInternetConnectionBlock:((_ httpRequest:HTTPRequest)->Void)?
    
    fileprivate var _isBlocked:Bool = false;
    
    fileprivate override init() {}
    
    //MARK: - Initialize
    open class func initialize(serverBaseURL:String, headers:HTTPHeaders?, authHeader:AuthHeader? = nil) {
        self.sharedInstance.initialize(serverBaseURL: serverBaseURL, headers:headers, authHeader: authHeader);
    } //F.E.
    
    fileprivate func initialize(serverBaseURL:String, headers:HTTPHeaders?, authHeader:AuthHeader? = nil) {
        //Base Server URL
        self._serverBaseURL = URL(string: serverBaseURL)!;
        
        //Http Headers
        self._headers = headers ?? HTTPHeaders();
        self._authHeader = authHeader;
        
        SyncEngine.initialize(_serverBaseURL, requestName:nil, headers: _headers.dictionary);
    } //F.E.
    
    //MARK: - Progress Bar Handling
    open class func setupProgressHUD(showProgress:@escaping ()->Void, hideProgress :@escaping ()->Void) {
        HTTPServiceManager.sharedInstance.setupProgressHUD(showProgress: showProgress, hideProgress: hideProgress);
    } //F.E.
    
    open func setupProgressHUD(showProgress:@escaping ()->Void, hideProgress:@escaping ()->Void) {
        //Show Progress Block
        _showProgressBlock = showProgress;
        
        //Hide Progress Block
        _hideProgressBlock = hideProgress;
    } //F.E.
    
    open class func onShowProgress(showProgress:@escaping ()->Void) {
        HTTPServiceManager.sharedInstance.onShowProgress(showProgress: showProgress);
    } //F.E.
    
    fileprivate func onShowProgress(showProgress:@escaping ()->Void) {
        _showProgressBlock = showProgress;
    } //F.E.
    
    open class func onHideProgress(hideProgress:@escaping ()->Void) {
        HTTPServiceManager.sharedInstance.onHideProgress(hideProgress: hideProgress);
    } //F.E.
    
    fileprivate func onHideProgress(hideProgress:@escaping ()->Void) {
        _hideProgressBlock = hideProgress;
    } //F.E.
    
    fileprivate func showProgressHUD() {
        if (_hudRetainCount == 0) {
            _showProgressBlock?();
        }
        
        _hudRetainCount += 1;
    } //F.E.
    
    fileprivate func hideProgressHUD() {
        _hudRetainCount -= 1;
        
        if (_hudRetainCount == 0) {
            _hideProgressBlock?();
        }
    } //F.E.
    
    //MARK: - Failure Default Response Handling
    open class func onFailure(failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        HTTPServiceManager.sharedInstance.onFailure(failureBlock: failureBlock);
    } //F.E.
    
    fileprivate func onFailure(failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        _failureBlock = failureBlock;
    } //F.E.
    
    open class func onInvalidSession(invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        HTTPServiceManager.sharedInstance.onInvalidSession(invalidSessionBlock: invalidSessionBlock);
    } //F.E.
    
    fileprivate func onInvalidSession(invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        _invalidSessionBlock = invalidSessionBlock;
    } //F.E.
    
    open class func onNoInternetConnection(noInternetConnectionBlock:((_ httpRequest:HTTPRequest) -> Void)?) {
        HTTPServiceManager.sharedInstance.onNoInternetConnection(noInternetConnectionBlock: noInternetConnectionBlock);
    } //F.E.
    
    fileprivate func onNoInternetConnection(noInternetConnectionBlock:((_ httpRequest:HTTPRequest) -> Void)?) {
        _noInternetConnectionBlock = noInternetConnectionBlock;
    } //F.E.
    
    //MARK: - Requests Handling
    @discardableResult open class func request(requestName:String, parameters:[String:Any]?, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return self.request(serviceBaseURL:nil, requestName: requestName, parameters: parameters, method: .post, showHud: true, delegate: delegate, blocking:blocking);
    }
    
    @discardableResult open class func request(requestName:String, parameters:[String:Any]?, showHud:Bool, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return self.request(serviceBaseURL:nil, requestName: requestName, parameters: parameters, method: .post, showHud: showHud, delegate: delegate, blocking:blocking);
    } //F.E.
    
    @discardableResult open class func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return self.request(serviceBaseURL:nil, requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate, blocking:blocking);
    } //F.E.
    
    @discardableResult open class func request(serviceBaseURL:URL?, requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return HTTPServiceManager.sharedInstance.request(serviceBaseURL:serviceBaseURL, requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate, multipart: false, blocking:blocking);
    } //F.E.
    
    fileprivate func request(serviceBaseURL:URL?, requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, multipart:Bool, blocking:Bool) -> HTTPRequest {
        
        assert(_serverBaseURL != nil, "HTTPServiceManager.initialize(serverBaseURL: authorizationHandler:) not called.");
        
        let httpRequest:HTTPRequest = HTTPRequest(requestName: requestName, parameters: parameters, method: method, headers: _headers);
        httpRequest.serverBaseURL = serviceBaseURL;
        httpRequest.delegate = delegate;
        httpRequest.hasProgressHUD = showHud;
        
        httpRequest.multipart = multipart;
        
        httpRequest.blocking = blocking;
        
        if (_isBlocked == false) {
            self.request(httpRequest: httpRequest);
        } else {
            self.requestGotHold(httpRequest: httpRequest);
        }
        
        return httpRequest;
    } //F.E.
    
    //MARK: - Multipart Requests Handling
    @discardableResult open class func multipartRequest(requestName:String, parameters:[String:Any]?, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return self.multipartRequest(serviceBaseURL:nil, requestName: requestName, parameters: parameters, method: .post, showHud: true, delegate: delegate, blocking:blocking);
    } //F.E.
    
    @discardableResult open class func multipartRequest(requestName:String, parameters:[String:Any]?, showHud:Bool, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return self.multipartRequest(serviceBaseURL:nil, requestName: requestName, parameters: parameters, method: .post, showHud: showHud, delegate: delegate, blocking:blocking);
    } //F.E.
    
    @discardableResult open class func multipartRequest(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return self.multipartRequest(serviceBaseURL:nil, requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate, blocking:blocking);
    } //F.E.
    
    @discardableResult open class func multipartRequest(serviceBaseURL:URL?, requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, blocking:Bool = false) -> HTTPRequest {
        return HTTPServiceManager.sharedInstance.request(serviceBaseURL:serviceBaseURL, requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate, multipart: true, blocking:blocking);
    } //F.E.

    //MARK: - Request Sending
    
    public func request(httpRequest:HTTPRequest) {
        //Validation for internet connection
        guard (REACHABILITY_HELPER.isInternetConnected) else {
            //Calling after delay so that block may initialize
            GISTUtility.delay(0.01, closure: {
                self.requestDidFailWithNoInternetConnection(httpRequest: httpRequest);
            });
            
            return;
        }
        
        let dataRequest:DataRequest = httpRequest.sendRequest();

        if let authHeader = self._authHeader {
            dataRequest.authenticate(username: authHeader.username, password: authHeader.password)
        }
        
        dataRequest.responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.mutableContainers) { (response:AFDataResponse<Any>) in
            self.responseResult(httpRequest: httpRequest, dataResponse: response);
        }
        
        //Request Did Start
        self.requestDidStart(httpRequest: httpRequest);
    } //F.E.
    
    fileprivate func runPendingRequests() {
        for i:Int in (0 ..< _requests.count) {
            let request:HTTPRequest = _requests[i];
            
            if (request.pending) {
                request.pending = false;
                
                self.request(httpRequest: request);
                
                break;
            }
        }
    } //F.E.
    
    //MARK: - Response Handling
    fileprivate func responseResult(httpRequest:HTTPRequest, dataResponse:AFDataResponse<Any>) {
        switch dataResponse.result
        {
        case .success:
            
            let statusCode:Int = dataResponse.response?.statusCode ?? 200;
            
            if statusCode >= 200 && statusCode <= 299 {
                self.requestDidSucceedWithData(httpRequest: httpRequest, data: dataResponse.value);
            } else {
                let dictData:[String:Any] = dataResponse.value as? [String:Any] ?? [:];
                
                let errorMessage:String = dictData["message"] as? String  ?? "Unknown error";

                let userInfo:[AnyHashable : Any] = [
                    NSLocalizedDescriptionKey: errorMessage,
                    "data":dictData
                ]
                
                let error = NSError(domain: "com.cubix.gist", code: statusCode, userInfo: (userInfo as! [String : Any]));
                
                if (statusCode == 403) {
                    //Invalid session
                    self.requestDidFailWithInvalidSession(httpRequest: httpRequest, error: error);
                } else {
                    //Error
                     self.requestDidFailWithError(httpRequest: httpRequest, error: error);
                }
            }

            
        case .failure (let err):
            let errorCode:Int = (err as NSError).code;
            let userInfo = [NSLocalizedDescriptionKey: err.localizedDescription]
            let error = NSError(domain: "com.cubix.gist", code: errorCode, userInfo: userInfo);
            
            self.requestDidFailWithError(httpRequest: httpRequest, error: error);
            
            //For Debug
            if let strData = dataResponse.data?.toString() {
                print("Response Data: \(strData)");
            }
        }
    } //F.E.
    
    fileprivate func requestDidSucceedWithData(httpRequest:HTTPRequest, data:Any?) {
        DispatchQueue.main.async {
            httpRequest.didSucceedWithData(data: data);
            
            //Did Finish
            self.requestDidFinish(httpRequest: httpRequest);
            
            self.runPendingRequests();
        }

    } //F.E.
    
    fileprivate func requestDidFailWithError(httpRequest:HTTPRequest, error:NSError) {
        if (httpRequest.didFailWithError(error: error) == false) {
            _failureBlock?(httpRequest, error);
        }

        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
        
        self.runPendingRequests();
    } //F.E.
    
    fileprivate func requestDidFailWithInvalidSession(httpRequest:HTTPRequest, error:NSError) {
        if (httpRequest.didFailWithInvalidSession(error: error) == false) {
            _invalidSessionBlock?(httpRequest, error);
        }
        
        //Did Finish
        //??self.requestDidFinish(httpRequest: httpRequest);
        
        //Canceling the current one and all pending requests
        self.cancelAllRequests();
    } //F.E.
    
    fileprivate func requestDidFailWithNoInternetConnection(httpRequest:HTTPRequest) {
        if (httpRequest.didFailWithNoInternetConnection() == false) {
            _noInternetConnectionBlock?(httpRequest);
        }
        
        //Canceling the current one and all pending requests
        self.cancelAllRequests();
    } //F.E.
    
    fileprivate func requestDidStart(httpRequest:HTTPRequest) {
        if (httpRequest.hasProgressHUD) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            
            self.showProgressHUD();
        }
        
        _isBlocked = httpRequest.blocking;
        
        //Holding reference
        if _requests.firstIndex(of: httpRequest) == nil {
            _requests.append(httpRequest);
        }

    } //F.E.
    
    fileprivate func requestDidFinish(httpRequest:HTTPRequest) {
        if (httpRequest.hasProgressHUD) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            
            self.hideProgressHUD();
        }
        
        _isBlocked = false;
        
        _requests.removeObject(httpRequest);
    } //F.E.
    
    fileprivate func requestGotHold(httpRequest:HTTPRequest) {
        
        httpRequest.pending = true;
        
        //Holding reference
        _requests.append(httpRequest);
    } //F.E.
    
    
    //MARK: - Cancel Request Handling
    open class func cancelRequest(requestName:String) {
        self.sharedInstance.cancelRequest(requestName: requestName);
    } //F.E.

    fileprivate func cancelRequest(requestName:String) {
        
        //Reversed loop because index may change ofter removing object from array
        for i:Int in (0 ..< _requests.count).reversed() {
            let request:HTTPRequest = _requests[i];
            
            if (request.requestName == requestName) {
                request.cancel();
                self.requestDidFinish(httpRequest: request);
            }
        }
        
    } //F.E.
    
    open class func cancelRequest(request:HTTPRequest) {
        self.sharedInstance.cancelRequest(request: request);
    } //F.E.
    
    fileprivate func cancelRequest(request:HTTPRequest) {
        request.cancel();
        
        self.requestDidFinish(httpRequest: request);
    } //F.E.
    
    open class func cancelAllRequests() {
        self.sharedInstance.cancelAllRequests();
    } //F.E.
    
    fileprivate func cancelAllRequests() {
        //Reversed loop because index may change ofter removing object from array
        for i:Int in (0 ..< _requests.count).reversed() {
            let request:HTTPRequest = _requests[i];
            
            request.cancel();
            self.requestDidFinish(httpRequest: request);
        }
    } //F.E.
    
} //CLS END

@objc public protocol HTTPRequestDelegate {
    @objc optional func requestDidSucceedWithData(httpRequest:HTTPRequest, data:Any?);
    @objc optional func requestDidFailWithError(httpRequest:HTTPRequest, error:NSError);
    @objc optional func requestDidFailWithInvalidSession(httpRequest:HTTPRequest, error:NSError);
    @objc optional func requestDidFailWithNoInternetConnection(httpRequest:HTTPRequest);
} //P.E.

open class HTTPRequest:NSObject {
  
    open var requestName:String!
    open var parameters:Parameters?
    open var method:HTTPMethod = .post
    open var serverBaseURL:URL?
    
    open var multipart:Bool = false;
    
    open var pending:Bool = false;
    open var blocking:Bool = false;
    
    fileprivate var _urlString:String?
    open var urlString:String {
        get {
            
            if (_urlString == nil) {
                _urlString = self.serverBaseURL != nil ?
                    self.serverBaseURL!.appendingPathComponent(requestName).absoluteString:
                    HTTPServiceManager.serverBaseURL.appendingPathComponent(requestName).absoluteString;
            }
            
            return _urlString!;
        }
        
        set {
            _urlString = newValue;
        }
    } //P.E.
    
    open var headers:HTTPHeaders?
    
    fileprivate weak var request:DataRequest?;
    
    open override var description: String {
        get {
            return "[HTTPRequest] [\(method)] \(String(describing: requestName)): \(String(describing: _urlString))";
        }
    } //P.E.
    
    open var hasProgressHUD:Bool = false;
    
    fileprivate var _successBlock:((_ data:Any?) -> Void)?
    fileprivate var _failureBlock:((_ error:NSError) -> Void)?
    fileprivate var _invalidSessionBlock:((_ error:NSError) -> Void)?
    
    fileprivate var _progressBlock:Request.ProgressHandler?
    
    fileprivate var _noInternetConnectionBlock:(() -> Void)?
    
    open weak var delegate:HTTPRequestDelegate?;
    
    private var _cancelled:Bool = false;
    private var cancelled:Bool {
        get {
            return _cancelled;
        }
    } //P.E.
    
    private override init() {
        super.init();
    } //C.E.
    
    public init(requestName:String, parameters:Parameters?, method:HTTPMethod, headers: HTTPHeaders? = nil) {
        super.init();
        
        self.requestName = requestName;
        self.parameters = parameters ?? [:];
        self.method = method;
        self.headers = headers ?? [:];


        if (HTTPServiceManager.sharedInstance.entityFramework) {
            //Default Params
            self.parameters?["mobile_json"] = true;
            
            // Entity Id & Actor ID
            if let userId:Int = GIST_GLOBAL.userData?[USER_ID] as? Int {
                self.headers?[USER_ID] = "\(userId)";
                self.parameters?["actor_user_id"] = userId;
            }
        }

        //Adding Language Key
        self.headers?["language"] = GIST_CONFIG.currentLanguageCode;
    } //C.E.
    
    open func sendRequest() -> DataRequest {
        
        //Update Access token
        if let accessToken:String = GIST_GLOBAL.accessToken {
            self.headers?["X-Access-Token"] = accessToken;
        }
        
        #if DEBUG
            print("------------------------------------------------------------------");
            print("url: \(self.urlString) params: \(String(describing: self.parameters)) headers: \(String(describing: self.headers))")
            print("------------------------------------------------------------------");
        #endif
        
        if (self.multipart) {
            //Multipart Request
            
            self.request = AF.upload(multipartFormData: { (formData:MultipartFormData) in
                if let params:Parameters = self.parameters {
                    for (key , value) in params {
                        if let files:[GISTFile] = value as? [GISTFile] {
                            for file in files {
                                formData.append(file.data, withName: key, fileName: "fileName.\(file.ext)", mimeType: file.mimeType); // Here file name does not matter.
                            }
                        } else if let file:GISTFile = value as? GISTFile {
                            formData.append(file.data, withName: key, fileName: "fileName.\(file.ext)", mimeType: file.mimeType); // Here file name does not matter.
                        } else if let data:Data = value as? Data {
                            formData.append(data, withName: key, fileName: "fileName.\(data.fileExtension)", mimeType: data.mimeType); // Here file name does not matter.
                        } else {
                            formData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                        }
                    }
                }
            }, to: self.urlString, method: self.method, headers: self.headers);
        } else {
            self.request = AF.request(self.urlString, method:self.method, parameters: self.parameters, encoding: URLEncoding.default, headers: self.headers)
        }
        
        return self.request!;
    } //F.E.
    
    //MARK: - Response Handling
    @discardableResult open func onSuccess(response:@escaping (_ data:Any?) -> Void) -> HTTPRequest {
        _successBlock = response;
        return self;
    } //F.E.
    
    @discardableResult open func onFailure(response:@escaping (_ error:NSError) -> Void) -> HTTPRequest {
        _failureBlock = response;
        return self;
    } //F.E.
    
    @discardableResult open func onInvalidSession(response:@escaping (_ error:NSError) -> Void) -> HTTPRequest {
        _invalidSessionBlock = response;
        return self;
    } //F.E.
    
    @discardableResult open func onNoInternetConnection(response:@escaping () -> Void) -> HTTPRequest {
        _noInternetConnectionBlock = response;
        return self;
    } //F.E.
    
    @discardableResult
    open func uploadProgress(closure: @escaping Request.ProgressHandler) -> Self {
        _progressBlock = closure;
        
        (self.request as? UploadRequest)?.uploadProgress(closure: closure);
        
        return self
    } //F.E.
    
    @discardableResult fileprivate func didSucceedWithData(data:Any?) -> Bool {
        guard (_cancelled == false) else {
            return true;
        }
        
        _successBlock?(data);
        
        self.delegate?.requestDidSucceedWithData?(httpRequest: self, data: data);
        
        return ((_successBlock != nil) || (self.delegate?.requestDidSucceedWithData != nil));
    } //F.E.
    
    @discardableResult fileprivate func didFailWithError(error:NSError) -> Bool {
        guard (_cancelled == false) else {
            return true;
        }
        
        _failureBlock?(error);
        
        delegate?.requestDidFailWithError?(httpRequest: self, error: error);
        
        return ((_failureBlock != nil) || (self.delegate?.requestDidFailWithError != nil));
    } //F.E.
    
    @discardableResult fileprivate func didFailWithInvalidSession(error:NSError) -> Bool {
        guard (_cancelled == false) else {
            return true;
        }
        
        _invalidSessionBlock?(error);
        
        delegate?.requestDidFailWithInvalidSession?(httpRequest: self, error: error);
        
        return ((_invalidSessionBlock != nil) || (self.delegate?.requestDidFailWithInvalidSession != nil));
    } //F.E.
    
    @discardableResult fileprivate func didFailWithNoInternetConnection() -> Bool {
        _noInternetConnectionBlock?();
        
        delegate?.requestDidFailWithNoInternetConnection?(httpRequest: self);
        
        return ((_noInternetConnectionBlock != nil) || (self.delegate?.requestDidFailWithNoInternetConnection != nil));
    } //F.E.
    
    //MARK: - Cancel
    
    //Should not be called directly from outside of the class
    fileprivate func cancel() {
        //Flaging On
        _cancelled = true;
        
        //Cancelling the request
        request?.cancel();
    } //F.E.
    
    
    deinit {
    }
    
} //CLS END


open class AuthHeader:NSObject {
    
    open var username:String!
    open var password:String!
    
    
    private override init() {
        super.init();
    } //C.E.
    
    public init(username:String, password:String) {
        super.init();
        
        self.username = username;
        self.password = password;
    } //F.E.
    
} //CLS END
