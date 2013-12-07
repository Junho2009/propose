package commons.module
{
    import flash.utils.Dictionary;
    
    public class ModuleManager implements IModuleManager
    {
        private var _moduleDic:Dictionary;
        
        
        public function ModuleManager()
        {
            _moduleDic = new Dictionary();
        }
        
        public function addModule(module:IModule):void
        {
            _moduleDic[module.name] = module;
        }
    }
}