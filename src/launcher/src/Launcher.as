package src
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.net.URLRequest;

    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.textures.BitmapTexture;

    /**
     * 启动器
     * @author Junho
     * <br/>Create: 2013.07.07
     */
    [SWF(width = "1000", height = "600", frameRate = 30
        , backgroundColor = "0x000000")]
    public class Launcher extends Sprite
    {
        private var _view:View3D;
        private var _plane:Mesh;

        private var _loader:Loader;

        private var _bKeyDown:Boolean = false;


        public function Launcher()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onAddedToStage(e:Event):void
        {
            _view = new View3D();
            stage.addChild(_view);

            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
            _loader.load(new URLRequest("res/bg.jpg"));

            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        private function onLoaded(e:Event):void
        {
            var bmp:Bitmap = _loader.content as Bitmap;
            var bmpTex:BitmapTexture = new BitmapTexture(bmp.bitmapData);
            var texMtr:TextureMaterial = new TextureMaterial(bmpTex);

            var planeGeom:PlaneGeometry = new PlaneGeometry(bmp.width
                , bmp.height);
            _plane = new Mesh(planeGeom, texMtr);
            _plane.mouseEnabled = true;
            trace(_plane.position);

            _view.camera.moveTo(-512, 800, -500);
            _view.camera.lookAt(new Vector3D(512, 0, 256));
            _view.scene.addChild(_plane);
        }

        private function onKeyDown(e:KeyboardEvent):void
        {
            _bKeyDown = true;
        }

        private function onKeyUp(e:KeyboardEvent):void
        {
            _bKeyDown = false;
        }

        private function onEnterFrame(e:Event):void
        {
            if (_bKeyDown)
                _plane.rotationY += 1;
            _view.render();
        }
    }
}
