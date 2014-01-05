package away3d
{
    import flash.events.Event;
    import flash.geom.Vector3D;
    
    import away3d.cameras.Camera3D;
    import away3d.cameras.lenses.OrthographicLens;
    import away3d.containers.Scene3D;
    import away3d.containers.View3D;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.manager.ISceneManager;
    
    /**
     * away3d的正交场景
     * @author junho
     * 
     */    
    public class Away3dOrthScene implements ISceneManager
    {
        private var _context:commons.GlobalContext;
        
        private var _view3d:View3D;
        private var _scene:Scene3D;
        private var _camera:Camera3D;
        
        private var _effects:Vector.<Away3dEffect>;
        
        
        public function Away3dOrthScene()
        {
            _context = commons.GlobalContext.getInstance();
            
            _scene = new Scene3D();
            
            var camLen:OrthographicLens = new OrthographicLens(_context.stage.stageHeight);
            camLen.near = 0;
            camLen.far = 1000;
            _camera = new Camera3D(camLen);
            
            _view3d = new View3D(_scene, _camera);
            
            _effects = new Vector.<Away3dEffect>();
            
            GlobalLayers.getInstance().bgLayer.addChild(_view3d);
            _context.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
            _context.stage.addEventListener(Event.RESIZE, onStageResized);
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
            
            _scene.addChild(effect);
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