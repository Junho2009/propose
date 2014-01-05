package away3d
{
    import flash.errors.IllegalOperationError;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import mx.utils.StringUtil;
    
    import away3d.core.base.Object3D;
    import away3d.entities.ParticleGroup;
    import away3d.events.AssetEvent;
    import away3d.events.LoaderEvent;
    import away3d.library.AssetLibrary;
    import away3d.library.assets.AssetType;
    
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    /**
     * away3d的资源加载器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class Away3dAssetLoader
    {
        private static const AssetType_Particle:String = "PARTICLE";
        
        private static var _allowInstance:Boolean = false;
        private static var _instance:Away3dAssetLoader = null;
        
        private var _loadMgr:ILoadManager;
        private var _cacheFlagDic:Dictionary;
        
        private var _reqInfoList:Vector.<LoadRequestInfo>;
        private var _curHandlingReq:LoadRequestInfo = null;
        
        
        public function Away3dAssetLoader()
        {
            if (!_allowInstance)
                throw new IllegalOperationError("Away3dAssetLoader is a singleton class.");
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            _cacheFlagDic = new Dictionary();
            
            _reqInfoList = new Vector.<LoadRequestInfo>();
            
            AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE
                , onAssetCompleted);
            AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE
                , onResourceCompleted);
        }
        
        public static function getInstance():Away3dAssetLoader
        {
            if (null == _instance)
            {
                _allowInstance = true;
                _instance = new Away3dAssetLoader();
                _allowInstance = false;
            }
            return _instance;
        }
        
        
        
        public function reqParticle(reqInfo:LoadRequestInfo):void
        {
            var assetName:String = genAssetKey(AssetType_Particle, reqInfo.url);
            const bCached:Boolean = _cacheFlagDic[assetName];
            if (bCached)
            {
                var particleGroup:ParticleGroup = AssetLibrary.getAsset(assetName) as ParticleGroup;
                var cloneParticleGroup:Object3D = particleGroup.clone();
                
                if (null != reqInfo.completedCallback)
                {
                    if (null == reqInfo.completedCallbackData)
                        reqInfo.completedCallback.apply(this, [cloneParticleGroup]);
                    else
                        reqInfo.completedCallback.apply(this, [cloneParticleGroup, _curHandlingReq.completedCallbackData]);
                }
            }
            else
            {
                var particleReq:LoadRequestInfo = reqInfo.clone();
                particleReq.param = {type: AssetType_Particle};
                _reqInfoList.push(particleReq);
                handleReq();
            }
        }
        
        
        
        private function handleReq():void
        {
            if (null != _curHandlingReq || 0 == _reqInfoList.length)
                return;
            
            _curHandlingReq = _reqInfoList.shift();
            
            var req:LoadRequestInfo = new LoadRequestInfo();
            req.url = _curHandlingReq.url;
            req.completedCallback = getLoadedCallbackByType(_curHandlingReq.param.type);
            _loadMgr.load(req);
        }
        
        private function getLoadedCallbackByType(type:String):Function
        {
            switch (type)
            {
                case AssetType_Particle:
                    return onParticleFileLoaded;
                    
                default:
                    return null;
            }
        }
        
        private function onParticleFileLoaded(data:ByteArray):void
        {
            AssetLibrary.loadData(data, null, null, new FixedUrlParticleGroupParser());
        }
        
        private function onAssetCompleted(e:AssetEvent):void
        {
            if (e.asset.assetType == AssetType.CONTAINER &&
                e.asset is ParticleGroup)
            {
                var particleGroup:ParticleGroup = e.asset as ParticleGroup;
                cacheParticle(particleGroup, _curHandlingReq.url);
                
                var cloneParticleGroup:Object3D = particleGroup.clone();
                
                if (null != _curHandlingReq.completedCallback)
                {
                    if (null == _curHandlingReq.completedCallbackData)
                        _curHandlingReq.completedCallback.apply(this, [cloneParticleGroup]);
                    else
                        _curHandlingReq.completedCallback.apply(this, [cloneParticleGroup, _curHandlingReq.completedCallbackData]);
                }
            }
        }
        
        private function onResourceCompleted(e:LoaderEvent):void
        {
            _curHandlingReq.dispose();
            _curHandlingReq = null;
            handleReq();
        }
        
        private function genAssetKey(type:String, url:String):String
        {
            var noRootUrl:String = FilePath.trimRoot(url);
            return StringUtil.substitute("{0}_{1}", type, noRootUrl);
        }
        
        private function cacheParticle(particle:ParticleGroup, url:String):void
        {
            var assetName:String = genAssetKey(AssetType_Particle, url);
            particle.name = assetName;
            AssetLibrary.addAsset(particle);
            _cacheFlagDic[assetName] = true;
        }
    }
}