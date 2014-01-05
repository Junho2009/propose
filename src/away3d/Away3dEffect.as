package away3d
{
    import mx.utils.StringUtil;
    
    import away3d.containers.ObjectContainer3D;
    import away3d.entities.ParticleGroup;
    import away3d.events.ParticleGroupEvent;
    
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    
    /**
     * away3d特效
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class Away3dEffect extends ObjectContainer3D
    {
        private var _assetLoader:Away3dAssetLoader;
        
        private var _particle:ParticleGroup = null;
        
        private var _id:uint = 0;
        private var _bReady:Boolean = false;
        private var _bLoading:Boolean = false;
        private var _bStarted:Boolean = false;
        private var _callback:Function = null;
        
        
        public function Away3dEffect(id:uint)
        {
            super();
            
            _assetLoader = Away3dAssetLoader.getInstance();
            _id = id;
        }
        
        public function set completedCallback(value:Function):void
        {
            _callback = value;
        }
        
        public function start():void
        {
            if (_bStarted)
                return;
            
            _bStarted = true;
            
            if (_bReady)
            {
                if (null != _particle.animator)
                    _particle.animator.start();
            }
            else if (!_bLoading)
            {
                _bLoading = true;
                
                var req:LoadRequestInfo = new LoadRequestInfo();
                req.url = StringUtil.substitute("{0}{1}.awp", FilePath.effect3dPath, _id);
                req.completedCallback = onParticleLoaded;
                _assetLoader.reqParticle(req);
            }
        }
        
        public function stop():void
        {
            if (!_bStarted)
                return;
            
            if (null != _particle && null != _particle.animator)
                _particle.animator.stop();
            
            _bStarted = false;
        }
        
        private function onParticleLoaded(particle:ParticleGroup):void
        {
            _particle = particle;
            addChild(particle);
            
            _bLoading = false;
            _bReady = true;
            
            _particle.animator.addEventListener(ParticleGroupEvent.OCCUR, onCustomEventOccur);
            
            if (_bStarted && null != particle.animator)
                particle.animator.start();
        }
        
        private function onCustomEventOccur(e:ParticleGroupEvent):void
        {
            if (e.eventProperty.customName == "completed")
            {
                if (null != _callback)
                    _callback(this);
            }
        }
    }
}