package ui
{
    import flash.display.Bitmap;

    public class HomePageWin extends WindowBase
    {
        [Embed(source = "../../../resources/homepage_bg.jpg")]
        private var bg:Class;
        
        
        public function HomePageWin()
        {
            super("HomePageWin", 0, 0);
        }
        
        override public function init():void
        {
            super.init();
            
            backgroundImage = new bg() as Bitmap;
            fullscreen = true;
        }
    }
}