//
//  HTTPServiceManager.swift
//  HttpReq
//
//  Created by Shoaib Abdul on 17/09/2016.
//  Copyright © 2016 Cubix Labs. All rights reserved.
//

import UIKit
import Alamofire

open class HTTPServiceManager: NSObject {
    
    open static let sharedInstance = HTTPServiceManager();
    
    fileprivate var _requests:[String:HTTPRequest] = [:];
    
    fileprivate var _headers:HTTPHeaders = HTTPHeaders();
    
    fileprivate var _serverBaseURL:URL!;
    open class var serverBaseURL:URL {
        get {
            return self.sharedInstance._serverBaseURL;
        }
        
        set {
            self.sharedInstance._serverBaseURL = newValue;
        }
    } //P.E.
    
    fileprivate var _hudRetainCount:Int = 0;
    
    fileprivate var _showProgressBlock:(()->Void)?
    fileprivate var _hideProgressBlock:(()->Void)?
    
    fileprivate var _failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?
    fileprivate var _invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?
    fileprivate var _noInternetConnectionBlock:((_ httpRequest:HTTPRequest)->Void)?
    
    fileprivate override init() {}
    
    //MARK: - Initialize
    open class func initialize(serverBaseURL:String) {
        self.sharedInstance.initialize(serverBaseURL: serverBaseURL, authorizationHandler:nil);
    } //F.E.
    
    open class func initialize(serverBaseURL:String, authorizationHandler: @autoclosure @escaping ()->(name:String, password:String)) {
        self.sharedInstance.initialize(serverBaseURL: serverBaseURL, authorizationHandler: authorizationHandler);
    } //F.E.
    
    fileprivate func initialize(serverBaseURL:String, authorizationHandler:(()->(name:String, password:String))?) {
        //Base Server URL
        _serverBaseURL = URL(string: serverBaseURL)!;
        
        let urlToSync:String = _serverBaseURL.appendingPathComponent("se/get_all").absoluteString;
        
        guard let authHeader = authorizationHandler?() else {
            return;
        }
        
        //Security Headers
        self.authorizationHeader(user: authHeader.name, password: authHeader.password);
        
        //Initializing Sync Engine
        SyncEngine.initialize(urlToSync, authorizationHandler: (name: authHeader.name, password: authHeader.password));
        
    } //F.E.
    
    //MARK: - Authorization Handling
    open class func authorizationHeader(user: String, password: String) {
        HTTPServiceManager.sharedInstance.authorizationHeader(user: user, password: password);
    } //F.E.
    
    fileprivate func authorizationHeader(user: String, password: String) {
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            _headers[authorizationHeader.key] = authorizationHeader.value;
        }
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
    @discardableResult open class func request(requestName:String, parameters:[String:Any]?, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        return self.request(requestName: requestName, parameters: parameters, method: .post, showHud: true, delegate: delegate);
    }
    
    @discardableResult open class func request(requestName:String, parameters:[String:Any]?, showHud:Bool, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        return self.request(requestName: requestName, parameters: parameters, method: .post, showHud: showHud, delegate: delegate);
    } //F.E.
    
    @discardableResult open class func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        return HTTPServiceManager.sharedInstance.request(requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate);
    } //F.E.
    
    fileprivate func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        
        assert(_serverBaseURL != nil, "HTTPServiceManager.initialize(serverBaseURL: authorizationHandler:) not called.");
        
        let httpRequest:HTTPRequest = HTTPRequest(requestName: requestName, parameters: parameters, method: method, headers: _headers);
        
        httpRequest.delegate = delegate;
        httpRequest.hasProgressHUD = showHud;
        
        self.request(httpRequest: httpRequest);
        
        return httpRequest;
    } //F.E.
    
    public func request(httpRequest:HTTPRequest) {
        //Validation for internet connection
        guard (REACHABILITY_HELPER.isInternetConnected) else {
            //Calling after delay so that block may initialize
            GISTUtility.delay(0.01, closure: {
                self.requestDidFailWithNoInternetConnection(httpRequest: httpRequest);
            });
            return;
        }
        
        httpRequest.sendRequest().responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.mutableContainers) {
            (response:DataResponse<Any>) -> Void in
            self.responseResult(httpRequest: httpRequest, response: response);
        }
        
        //Request Did Start
        self.requestDidStart(httpRequest: httpRequest);
    } //F.E.
    
    //MARK: - Multipart Requests Handling
    @discardableResult open class func multipartRequest(requestName:String, parameters:[String:Any]?, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        return self.multipartRequest(requestName: requestName, parameters: parameters, method: .post, showHud: true, delegate: delegate);
    } //F.E.
    
    @discardableResult open class func multipartRequest(requestName:String, parameters:[String:Any]?, showHud:Bool, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        return self.multipartRequest(requestName: requestName, parameters: parameters, method: .post, showHud: showHud, delegate: delegate);
    } //F.E.
    
    @discardableResult open class func multipartRequest(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        return HTTPServiceManager.sharedInstance.multipartRequest(requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate);
    } //F.E.
    
    fileprivate func multipartRequest(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?) -> HTTPRequest {
        
        assert(_serverBaseURL != nil, "HTTPServiceManager.initialize(serverBaseURL: authorizationHandler:) not called.");
        
        let httpRequest:HTTPRequest = HTTPRequest(requestName: requestName, parameters: parameters, method: method, headers: _headers);
        
        httpRequest.delegate = delegate;
        httpRequest.hasProgressHUD = showHud;
        
        self.multipartRequest(httpRequest: httpRequest);
        
        return httpRequest;
    } //F.E.
    
    public func multipartRequest(httpRequest:HTTPRequest) {
        
        //Validation for internet connection
        guard (REACHABILITY_HELPER.isInternetConnected) else {
            //Calling after delay so that block may initialize
            GISTUtility.delay(0.01, closure: {
                self.requestDidFailWithNoInternetConnection(httpRequest: httpRequest);
            });
            return;
        }
        
        httpRequest.sendMultipartRequest(multipartEncodingResult: multipartEncodingResult);
        
        //Request Did Start
        self.requestDidStart(httpRequest: httpRequest);
    } //F.E.
    
    fileprivate func multipartEncodingResult(httpRequest:HTTPRequest, encodingCompletion:SessionManager.MultipartFormDataEncodingResult) {
        
        switch encodingCompletion {
        case .success(let req, _, _):
            httpRequest.request = req; //Holding alamofire Request instance
            
            //Setting Progress block
            if let progressHandler:Request.ProgressHandler = httpRequest._progressBlock {
                req.uploadProgress(closure: progressHandler);
            }
            
            req.responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.mutableContainers) {
                (response:DataResponse<Any>) -> Void in
                self.responseResult(httpRequest: httpRequest, response: response);
            }
        case .failure(let errorType):
            self.requestDidFailWithError(httpRequest: httpRequest, error: errorType as NSError);
        }
    } //F.E.
    
    //MARK: - Response Handling
    fileprivate func responseResult(httpRequest:HTTPRequest, response:DataResponse<Any>) {
        switch response.result
        {
        case .success:
            if let dictData = response.result.value as? NSMutableDictionary {
                
                let message:String? = dictData["message"] as? String;

                let errorCode:Int = (dictData["error"] as? Int) ?? 0;
                let invalidSession:Int = (dictData["kick_user"] as? Int) ?? 0;

                //If api is not as per Cubix Standard, return response as it is.
                if (errorCode == 0 && dictData["data"] == nil) {
                    self.requestDidSucceedWithData(httpRequest: httpRequest, data: dictData);
                    return;
                }
                
                if (errorCode == 0 && invalidSession == 0) {
                    let data:Any? = dictData["data"];
                    
                    if let msg:String = message, msg != ""  {
                        
                        let rtnData:NSMutableDictionary
                        
                        if let subData:NSMutableDictionary =  data as? NSMutableDictionary {
                            rtnData = subData;
                        } else {
                            rtnData = NSMutableDictionary();
                            
                            if let sData:Any = data  {
                                rtnData["data"] = sData;
                            }
                        }
                        
                        rtnData["message"] = msg;
                        
                        self.requestDidSucceedWithData(httpRequest: httpRequest, data: rtnData);
                    } else {
                        self.requestDidSucceedWithData(httpRequest: httpRequest, data: data);
                    }
                    
                } else {
                    //Failure
                    let errorMessage: String = message ?? "Unknown error";
                    let data: [String:Any] = dictData["data"] as? [String:Any] ?? [:];
                    
                    let userInfo:[AnyHashable : Any] = [
                        NSLocalizedDescriptionKey: errorMessage,
                        "data":data
                    ]
                    
                    let error = NSError(domain: "com.cubix.gist", code: errorCode, userInfo: userInfo);
                    
                    if (invalidSession == 0) {
                        self.requestDidFailWithError(httpRequest: httpRequest, error: error);
                    } else {
                        self.requestDidFailWithInvalidSession(httpRequest: httpRequest, error: error);
                    }
                }
            } else {
                
                //Failure
                let errorMessage: String = "Unknown error";
                let userInfo = [NSLocalizedDescriptionKey: errorMessage]
                let error = NSError(domain: "com.cubix.gist", code: 404, userInfo: userInfo);
                
                self.requestDidFailWithError(httpRequest: httpRequest, error: error);
            }

        case .failure (let err):
            let errorCode:Int = (err as NSError).code;
            let userInfo = [NSLocalizedDescriptionKey: err.localizedDescription]
            let error = NSError(domain: "com.cubix.gist", code: errorCode, userInfo: userInfo);
            
            self.requestDidFailWithError(httpRequest: httpRequest, error: error);
            
            //For Debug
            if let responseData = response.data?.toString() {
                print("Response Data: \(responseData)");
            }
        }
    } //F.E.
    
    fileprivate func requestDidSucceedWithData(httpRequest:HTTPRequest, data:Any?) {
        httpRequest.didSucceedWithData(data: data);
        
        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
    } //F.E.
    
    fileprivate func requestDidFailWithError(httpRequest:HTTPRequest, error:NSError) {
        if (httpRequest.didFailWithError(error: error) == false) {
            _failureBlock?(httpRequest, error);
        }

        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
    } //F.E.
    
    fileprivate func requestDidFailWithInvalidSession(httpRequest:HTTPRequest, error:NSError) {
        if (httpRequest.didFailWithInvalidSession(error: error) == false) {
            _invalidSessionBlock?(httpRequest, error);
        }
        
        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
    } //F.E.
    
    fileprivate func requestDidFailWithNoInternetConnection(httpRequest:HTTPRequest) {
        if (httpRequest.didFailWithNoInternetConnection() == false) {
            _noInternetConnectionBlock?(httpRequest);
        }
    } //F.E.
    
    fileprivate func requestDidStart(httpRequest:HTTPRequest) {
        if (httpRequest.hasProgressHUD) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            
            self.showProgressHUD();
        }
        
        //Holding reference
        _requests[httpRequest.requestName] = httpRequest;
    } //F.E.
    
    fileprivate func requestDidFinish(httpRequest:HTTPRequest) {
        if (httpRequest.hasProgressHUD) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            
            self.hideProgressHUD();
        }
        
        _requests.removeValue(forKey: httpRequest.requestName);
    } //F.E.
    
    //MARK: - Cancel Request Handling
    open class func cancelRequest(requestName:String) {
        self.sharedInstance.cancelRequest(requestName: requestName);
    } //F.E.
    
    fileprivate func cancelRequest(requestName:String) {
        if let httpRequest:HTTPRequest = _requests[requestName] {
            httpRequest.cancel();
            
            self.requestDidFinish(httpRequest: httpRequest);
        }
    } //F.E.
    
    open class func cancelAllRequests() {
        self.sharedInstance.cancelAllRequests();
    } //F.E.
    
    fileprivate func cancelAllRequests() {
        for (_, httpRequest) in _requests {
            httpRequest.cancel();
            
            self.requestDidFinish(httpRequest: httpRequest);
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
    
    fileprivate var _urlString:String?
    open var urlString:String {
        get {
            
            if (_urlString == nil) {
                _urlString = HTTPServiceManager.serverBaseURL.appendingPathComponent(requestName).absoluteString;
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
            return "[HTTPRequest] [\(method)] \(requestName): \(String(describing: _urlString))";
        }
    } //P.E.
    
    open var hasProgressHUD:Bool = false;
    
    fileprivate var _successBlock:((_ data:Any?) -> Void)?
    fileprivate var _failureBlock:((_ error:NSError) -> Void)?
    fileprivate var _invalidSessionBlock:((_ error:NSError) -> Void)?
    
    fileprivate var _progressBlock:Request.ProgressHandler?
    
    fileprivate var _noInternetConnectionBlock:(() -> Void)?
    
    open weak var delegate:HTTPRequestDelegate?;
    
    fileprivate var _cancelled:Bool = false;
    fileprivate var cancelled:Bool {
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
        self.parameters = parameters;
        self.method = method;
        self.headers = headers;

        //Default Params
        if (self.parameters != nil) {
            self.parameters!["mobile_json"] = true;
        } else {
            self.parameters = ["mobile_json":true];
        }
        
        //Client Token
        if let clientToken:String = GIST_GLOBAL.userData?["client_token"] as? String {
            self.headers?["client_token"] = clientToken;
        }
        
        // Entity Id & Actor ID
        if let entityId:Int = GIST_GLOBAL.userData?["entity_id"] as? Int {
            
            self.headers?["entity_id"] = "\(entityId)";
            self.parameters?["actor_user_id"] = entityId;
        } else if let userId:Int = GIST_GLOBAL.userData?["user_id"] as? Int {
            self.headers?["user_id"] = "\(userId)";
            self.parameters?["actor_user_id"] = userId;
        }
        
        //Adding Language Key
        self.headers?["language"] = GIST_CONFIG.currentLanguageCode;
    } //C.E.
    
    open func sendRequest() -> DataRequest {
        #if DEBUG
            print("------------------------------------------------------------------");
            print("url: \(self.urlString) params: \(String(describing: self.parameters)) headers: \(String(describing: self.headers))")
            print("------------------------------------------------------------------");
        #endif
        
        self.request = Alamofire.request(self.urlString, method:self.method, parameters: self.parameters, encoding: URLEncoding.default, headers: self.headers);
        return self.request!;
    } //F.E.
    
    open func sendMultipartRequest(multipartEncodingResult:@escaping ((_ httpRequest:HTTPRequest, _ encodingCompletion:SessionManager.MultipartFormDataEncodingResult) -> Void)) {
        
        
        Alamofire.upload(multipartFormData: { (formData:MultipartFormData) in
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
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: self.urlString, method: self.method, headers: self.headers, encodingCompletion: { (result:SessionManager.MultipartFormDataEncodingResult) -> Void in
            multipartEncodingResult(self, result);
        });
        
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
    open func cancel() {
        //Flaging On
        _cancelled = true;
        
        //Cancelling the request
        request?.cancel();
    } //F.E.
    
    
    deinit {
    }
    
} //CLS END


