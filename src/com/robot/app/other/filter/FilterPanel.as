package com.robot.app.other.filter
{
    import com.robot.core.config.ClientConfig;
    import com.robot.core.manager.ModuleManager;
    import com.robot.core.mode.AppModel;
    import flash.display.MovieClip;
    import com.robot.core.newloader.MCLoader;
    import com.robot.core.event.MCLoadEvent;
    import org.taomee.utils.DisplayUtil;
    import org.taomee.utils.AlignType;
    import com.robot.core.manager.LevelManager;
    import flash.system.ApplicationDomain;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.display.Loader;
    import com.robot.core.ui.alert.Alarm;
    import flash.net.URLRequest;
    import flash.display.LoaderInfo;
    import flash.utils.setTimeout;
    import org.taomee.manager.ResourceManager;
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
    import flash.filters.ColorMatrixFilter;

    public class FilterPanel extends Sprite
    {
        private var PATH:String = "resource/module/other/filterPanel.swf?20250323-1";

        private static const PET_PATH:String = "resource/fightResource/pet/swf/";

        private var mc:MovieClip;

        public var app:ApplicationDomain;

        private var _beforeBG:MovieClip;

        private var _afterBG:MovieClip;

        private var _loadPetBtn:SimpleButton;

        private var _sendBtn:SimpleButton;

        private var _petIDInputBox:TextField;

        private var _filterInputBox:TextField;

        private var _glowInputBox:TextField;

        private var assetsObj:Object;

        private var currentID:int = 1;

        private var petLoader:Loader = new Loader();

        protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);

        public function FilterPanel()
        {
            super();
        }

        public function show():void
        {
            var loader:MCLoader = null;
            if (!mc)
            {
                loader = new MCLoader(this.PATH, this, 1, "正在打开异色生成面板");
                loader.addEventListener(MCLoadEvent.SUCCESS, this.onLoad);
                loader.doLoad();
                petLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPetAsset);
            }
            else
            {
                DisplayUtil.align(this, null, AlignType.MIDDLE_CENTER);
                LevelManager.closeMouseEvent();
                LevelManager.appLevel.addChild(this);
            }
        }
        private function onLoad(event:MCLoadEvent):void
        {
            this.app = event.getApplicationDomain();
            this.mc = new (this.app.getDefinition("colorMatrixFilterPanel") as Class)() as MovieClip;
            this._loadPetBtn = this.mc["loadPetBtn"];
            this._sendBtn = this.mc["sendBtn"];
            this._beforeBG = this.mc["beforeBG"];
            this._afterBG = this.mc["afterBG"];
            this._petIDInputBox = this.mc["writeTxt"];
            this._petIDInputBox.restrict = "0-9";
            this._glowInputBox = this.mc["glowTxt"];
            this._glowInputBox.restrict = "0-9\,\.";
            this._filterInputBox = this.mc["filterTxt"];
            this._filterInputBox.restrict = "0-9\\-\,\.";
            var closeBtn:SimpleButton = this.mc["closeBtn"];
            closeBtn.addEventListener(MouseEvent.CLICK, this.closeHandler);
            this._loadPetBtn.addEventListener(MouseEvent.CLICK, this.loadPetAsset);
            this._sendBtn.addEventListener(MouseEvent.CLICK, this.setFilter);
            addChild(this.mc);
            DisplayUtil.align(this, null, AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(this);
            loadPetAsset(new MouseEvent(MouseEvent.CLICK));
        }
        private function closeHandler(event:MouseEvent):void
        {
            DisplayUtil.removeForParent(this);
            LevelManager.openMouseEvent();
        }

        private function loadPetAsset(e:MouseEvent):void
        {
            currentID = int(this._petIDInputBox.text);
            if (currentID < 1)
            {
                Alarm.show("请输入正确的精灵ID");
                return;
            }
            while (this._beforeBG.numChildren > 0)
            {
                this._beforeBG.removeChildAt(0);
            }
            while (this._afterBG.numChildren > 0)
            {
                this._afterBG.removeChildAt(0);
            }
            var petAsset:MovieClip = this.getAssetsByID(currentID);
            if (!petAsset)
            {
                petLoader.load(new URLRequest(PET_PATH + currentID + ".swf"));
            }
            else
            {
                petAsset.x = 120;
                petAsset.y = 0;
                petAsset.scaleX = petAsset.scaleY = petAsset.width > 400 ? 0.8 : 1;
                petAsset.gotoAndStop(1);
                petAsset.filters = [filte]
                this._beforeBG.addChild(petAsset);
            }
        }

        private function onLoadPetAsset(onloadEvent:Event):void
        {
            var applicationDomain:ApplicationDomain = (onloadEvent.target as LoaderInfo).applicationDomain;
            this.addAsset(currentID, applicationDomain);
            var petAsset:MovieClip = this.getAssetsByID(currentID);
            if(petAsset)
            {
                petAsset.x = 120;
                petAsset.y = 0;
                petAsset.scaleX = petAsset.scaleY = petAsset.width > 400 ? 0.8 : 1;
                petAsset.gotoAndStop(1);
                petAsset.filters = [filte]
                this._beforeBG.addChild(petAsset);
            }
        }
        private function addAsset(id:int, app:ApplicationDomain):void
        {
            if (!assetsObj)
            {
                assetsObj = {};
                defaultID = id;
            }
            assetsObj["asset_" + id] = app;
        }
        private function getAssetsByID(id:int):MovieClip
        {
            try
            {
                var petFightResource:Class = (assetsObj["asset_" + id] as ApplicationDomain).getDefinition("pet") as Class;
                return new petFightResource() as MovieClip;
            }
            catch (error:Error)
            {
                return null;
            }
        }

        private function setFilter(e:MouseEvent):void
        {
            var glow:String = this._glowInputBox.text;
            var glowArray:Array = glow.split(",");
            if(glowArray.length != 5)
            {
                Alarm.show("光晕参数必须为5，请检查之后重新加载！")
                return
            }
            var shiny:String = this._filterInputBox.text;
            var shinyArray:Array = shiny.split(",");
            if(shinyArray.length != 20)
            {
                Alarm.show("滤镜参数需为5*4的矩阵，请检查之后重新加载！")
                return
            }
            try
            {
                var matrix:ColorMatrixFilter = new ColorMatrixFilter(shinyArray)
                var glowFilter:GlowFilter = new GlowFilter(uint(glowArray[0]),int(glowArray[1]),int(glowArray[2]),int(glowArray[3]),int(glowArray[4]));
            }
            catch (error:Error)
            {
                Alarm.show("初始化滤镜时出错，请检查之后重新加载！")
                return
            }
            while (this._afterBG.numChildren > 0)
            {
                this._afterBG.removeChildAt(0);
            }
            var petAsset:MovieClip = this.getAssetsByID(currentID);
            if(petAsset)
            {
                petAsset.x = 120;
                petAsset.y = 0;
                petAsset.scaleX = petAsset.scaleY = petAsset.width > 400 ? 0.8 : 1;
                petAsset.gotoAndStop(1);
                petAsset.filters = [filte , glowFilter , matrix]
                this._afterBG.addChild(petAsset);
            }
        }
    }
}
