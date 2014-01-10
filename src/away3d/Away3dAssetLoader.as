package away3d
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.errors.IllegalOperationError;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import mx.utils.StringUtil;
    
    import away3d.core.base.Object3D;
    import away3d.entities.ParticleGroup;
    import away3d.events.AssetEvent;
    import away3d.events.LoaderEvent;
    import away3d.library.AssetLibrary;
    import away3d.library.assets.AssetType;
    import away3d.textures.BitmapTexture;
    import away3d.tools.utils.TextureUtils;
    
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
        public static const TexAlign_Center:String = "center";
        public static const TexAlign_LeftTop:String = "lefttop";
        
        
        private static const AssetType_Particle:String = "PARTICLE";
        private static const AssetType_Texture:String = "TEXTURE";
        
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
                var req:LoadRequestInfo = reqInfo.clone();
                req.param = {type: AssetType_Particle};
                _reqInfoList.push(req);
                handleReq();
            }
        }
        
        public function reqTexture(reqInfo:LoadRequestInfo):void
        {
            var assetName:String = genAssetKey(AssetType_Texture, reqInfo.url);
            const bCached:Boolean = _cacheFlagDic[assetName];
            if (bCached)
            {
                var texture:BitmapTexture = AssetLibrary.getAsset(assetName) as BitmapTexture;
                
                if (null != reqInfo.completedCallback)
                {
                    if (null == reqInfo.completedCallbackData)
                        reqInfo.completedCallback.apply(this, [texture]);
                    else
                        reqInfo.completedCallback.apply(this, [texture, _curHandlingReq.completedCallbackData]);
                }
            }
            else
            {
                var req:LoadRequestInfo = reqInfo.clone();
                req.param = {type: AssetType_Texture, orgParam: reqInfo.param};
                _reqInfoList.push(req);
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
        
        private function handleNextReq():void
        {
            _curHandlingReq.dispose();
            _curHandlingReq = null;
            handleReq();
        }
        
        private function getLoadedCallbackByType(type:String):Function
        {
            switch (type)
            {
                case AssetType_Particle:
                    return onParticleFileLoaded;
                    
                case AssetType_Texture:
                    return onTextureImgLoaded;
                    
                default:
                    return null;
            }
        }
        
        private function onParticleFileLoaded(data:ByteArray):void
        {
            AssetLibrary.loadData(data, null, null, new FixedUrlParticleGroupParser());
        }
        
        private function onTextureImgLoaded(bitmap:Bitmap):void
        {
            var align:String = TexAlign_Center;
            if (null != _curHandlingReq.param.orgParam && _curHandlingReq.param.orgParam.hasOwnProperty("align"))
                align = _curHandlingReq.param.orgParam.align;
            
            var bd:BitmapData = genPower2BitmapData(bitmap.bitmapData, align);
            var texture:BitmapTexture = new BitmapTexture(bd);
            
            cacheTexture(texture, _curHandlingReq.url);
            
            if (null != _curHandlingReq.completedCallback)
            {
                if (null == _curHandlingReq.completedCallbackData)
                    _curHandlingReq.completedCallback.apply(this, [texture]);
                else
                    _curHandlingReq.completedCallback.apply(this, [texture, _curHandlingReq.completedCallbackData]);
            }
            
            handleNextReq();
        }
        
        private static function genPower2BitmapData(source:BitmapData, align:String):BitmapData
        {
            var bNeedToRecreateBD:Boolean = false;
            
            var w:uint = source.width;
            var h:uint = source.height;
            
            if (!TextureUtils.isPowerOfTwo(w))
            {
                w = TextureUtils.getBestPowerOf2(w);
                bNeedToRecreateBD = true;
            }
            if (!TextureUtils.isPowerOfTwo(h))
            {
                h = TextureUtils.getBestPowerOf2(h);
                bNeedToRecreateBD = true;
            }
            
            if (!bNeedToRecreateBD)
                return source;
            
            var destPoint:Point = null;
            if ("center" == align)
                destPoint = new Point(w - source.width >> 1, h - source.height >> 1);
            else if ("lefttop" == align)
                destPoint = new Point(0, 0);
            else if ("centertop" == align)
                destPoint = new Point(w - source.width >> 1, 0);
            else // 预留
                destPoint = new Point(w - source.width >> 1, h - source.height >> 1);
            
            var bd:BitmapData = new BitmapData(w, h, true, 0x00000000);
            bd.copyPixels(source, new Rectangle(0, 0, source.width, source.height), destPoint);
            return bd;
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
        
        private function cacheTexture(texture:BitmapTexture, url:String):void
        {
            var assetName:String = genAssetKey(AssetType_Texture, url);
            texture.name = assetName;
            AssetLibrary.addAsset(texture);
            _cacheFlagDic[assetName] = true;
        }
    }
}