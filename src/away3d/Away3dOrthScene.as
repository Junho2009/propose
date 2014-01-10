package away3d
{
    import flash.events.Event;
    import flash.geom.Vector3D;
    
    import away3d.cameras.Camera3D;
    import away3d.cameras.lenses.OrthographicLens;
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.Scene3D;
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.textures.BitmapTexture;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.buses.InnerEventBus;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.ISceneManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import login.LoginEvent;
    
    /**
     * away3d的正交场景
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class Away3dOrthScene implements ISceneManager
    {
        private var _loadMgr:ILoadManager;
        private var _context:commons.GlobalContext;
        
        private var _view3d:View3D;
        private var _scene:Scene3D;
        private var _camera:Camera3D;
        
        private var _bgLayer:ObjectContainer3D;
        private var _bgMesh:Mesh;
        
        private var _effectLayer:ObjectContainer3D;
        private var _effects:Vector.<Away3dEffect>;
        
        
        public function Away3dOrthScene()
        {
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            
            _context = commons.GlobalContext.getInstance();
            
            _scene = new Scene3D();
            
            var camLen:OrthographicLens = new OrthographicLens(_context.stage.stageHeight);
            camLen.near = 0;
            camLen.far = 1000;
            _camera = new Camera3D(camLen);
            
            _view3d = new View3D(_scene, _camera);
            
            _bgLayer = new ObjectContainer3D();
            _scene.addChild(_bgLayer);
            
            _bgMesh = new Mesh(new PlaneGeometry(1, 1));
            _bgMesh.rotationX = -90;
            _bgLayer.addChild(_bgMesh);
            
            _effectLayer = new ObjectContainer3D();
            _scene.addChild(_effectLayer);
            
            _effects = new Vector.<Away3dEffect>();
            
            GlobalLayers.getInstance().scene3dLayer.addChild(_view3d);
            _context.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
            _context.stage.addEventListener(Event.RESIZE, onStageResized);
            
            InnerEventBus.getInstance().addEventListener(LoginEvent.LoginSuccessfully, onLogined);
        }
        
        public function playEffect(id:uint):void
        {
            var effect:Away3dEffect = new Away3dEffect(id);
            effect.completedCallback = function(e:Away3dEffect):void
            {
                removeEffect(e);
            };
            
            var cameraPos:Vector3D = _camera.position.clone();
            cameraPos.y -= _context.stage.stageHeight / 2;
            effect.moveTo(cameraPos.x, cameraPos.y, cameraPos.z+800);
            
            _effectLayer.addChild(effect);
            _effects.push(effect);
            
            effect.start();
        }
        
        
        
        private function onEnterFrame(e:Event):void
        {
            _view3d.render();
        }
        
        private function onStageResized(e:Event):void
        {
            (_camera.lens as OrthographicLens).projectionHeight = _context.stage.stageHeight;
        }
        
        private function onLogined(e:LoginEvent):void
        {
            InnerEventBus.getInstance().removeEventListener(LoginEvent.LoginSuccessfully, onLogined);
            
            var bgReq:LoadRequestInfo = new LoadRequestInfo();
            bgReq.url = FilePath.adapt + "homepage_bg.jpg";
            bgReq.completedCallback = onBGLoaded;
            Away3dAssetLoader.getInstance().reqTexture(bgReq);
        }
        
        private function onBGLoaded(texture:BitmapTexture):void
        {
            _bgMesh.geometry = new PlaneGeometry(texture.width, texture.height);
            _bgMesh.material = new TextureMaterial(texture);
        }
        
        private function removeEffect(effect:Away3dEffect):void
        {
            const idx:int = _effects.indexOf(effect);
            if (idx < 0)
                return;
            
            effect.stop();
            if (null != effect.parent)
                effect.parent.removeChild(effect);
            
            _effects.splice(idx, 1);
        }
    }
}