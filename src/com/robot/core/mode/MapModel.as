package com.robot.core.mode
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.controller.MapController;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.UserEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.loading.Loading;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.algo.IMapModel;
   import org.taomee.utils.DisplayUtil;
   
   public class MapModel implements IMapModel
   {
      private var _id:uint;
      
      private var _width:int = 960;
      
      private var _height:int = 560;
      
      private var _gridSize:uint = 10;
      
      private var _gridX:uint;
      
      private var _gridY:uint;
      
      private var _gridTotal:uint;
      
      private var _data:Array;
      
      private var _depthLevel:DisplayObjectContainer;
      
      private var _typeLevel:DisplayObjectContainer;
      
      private var _topLevel:DisplayObjectContainer;
      
      private var _root:DisplayObjectContainer;
      
      private var _spaceLevel:Sprite;
      
      private var _backLevel:Bitmap;
      
      private var _controlLevel:DisplayObjectContainer;
      
      private var _btnLevel:DisplayObjectContainer;
      
      private var _animatorLevel:DisplayObjectContainer;
      
      private var _loader:MCLoader;
      
      private var _timeoutID:uint;
      
      private var _isCanClose:Boolean = true;
      
      private var _allowData:Array = new Array();
      
      public function MapModel(mapID:uint, isCanClose:Boolean = true, isShowLoading:Boolean = true)
      {
         super();
         this._isCanClose = isCanClose;
         this._id = mapID;
         this.loadMap(isShowLoading);
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function get topLevel() : DisplayObjectContainer
      {
         return this._topLevel;
      }
      
      public function get typeLevel() : DisplayObjectContainer
      {
         return this._typeLevel;
      }
      
      public function get depthLevel() : DisplayObjectContainer
      {
         return this._depthLevel;
      }
      
      public function get backLevel() : Bitmap
      {
         return this._backLevel;
      }
      
      public function get spaceLevel() : DisplayObjectContainer
      {
         return this._spaceLevel;
      }
      
      public function get controlLevel() : DisplayObjectContainer
      {
         return this._controlLevel;
      }
      
      public function get btnLevel() : DisplayObjectContainer
      {
         return this._btnLevel;
      }
      
      public function get animatorLevel() : DisplayObjectContainer
      {
         return this._animatorLevel;
      }
      
      public function get width() : int
      {
         return this._spaceLevel.width;
      }
      
      public function get height() : int
      {
         return this._spaceLevel.height;
      }
      
      public function get gridSize() : uint
      {
         return this._gridSize;
      }
      
      public function get gridX() : uint
      {
         return this._gridX;
      }
      
      public function get gridY() : uint
      {
         return this._gridY;
      }
      
      public function get gridTotal() : uint
      {
         return this._gridTotal;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function get allowData() : Array
      {
         return this._allowData;
      }
      
      public function addUser(us:BasePeoleModel) : void
      {
         var id:uint = us.info.userID;
         if(!UserManager.contains(id))
         {
            UserManager.addUser(id,us);
            this._depthLevel.addChild(us);
         }
      }
      
      public function removeUser(userID:uint) : void
      {
         var us:BasePeoleModel = UserManager.removeUser(userID);
         if(Boolean(us))
         {
            us.stop();
            if(this._depthLevel.contains(us))
            {
               this._depthLevel.removeChild(us);
            }
            UserManager.dispatchEvent(new UserEvent(UserEvent.REMOVED_FROM_MAP,us.info));
            us.destroy();
            us = null;
         }
      }
      
      public function closeChange() : void
      {
         this._loader.clear();
         this._loader = null;
      }
      
      public function destroy() : void
      {
         var o:PeopleModel = null;
         var uArr:Array = UserManager.getUserModelList();
         for each(o in uArr)
         {
            o.stop();
            o.destroy();
            o = null;
         }
         UserManager.clear();
         AimatController.destroy();
         DisplayUtil.removeAllChild(this._root);
         this._data = null;
         this._loader.clear();
         this._loader = null;
         this._backLevel.bitmapData.dispose();
         this._backLevel = null;
         this._depthLevel = null;
         this._typeLevel = null;
         this._topLevel = null;
         this._root = null;
         this._spaceLevel = null;
         this._controlLevel = null;
         this._btnLevel = null;
      }
      
      public function isBlock(p:Point) : Boolean
      {
         var px:int = int(p.x / this._gridSize);
         var py:int = int(p.y / this._gridSize);
         if(px < 0 || px >= this._gridX || py < 0 || py >= this._gridY)
         {
            return false;
         }
         return this._data[px][py];
      }
      
      public function closeLoading() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.closeLoading();
         }
      }
      
      public function makeMapArray() : void
      {
         var offsetSize:uint = 0;
         var i:uint = 0;
         var j:uint = 0;
         var p:Point = new Point();
         var _hitBMD:BitmapData = new BitmapData(this.width,this.height,true,0);
         _hitBMD.draw(this._typeLevel);
         this._data = new Array(this._gridX);
         offsetSize = uint(int(this._gridSize / 2));
         for(i = 0; i < this._gridX; i++)
         {
            this._data[i] = new Array(this._gridY);
            for(j = 0; j < this._gridY; j++)
            {
               if(Boolean(_hitBMD.getPixel32(i * this._gridSize + offsetSize,j * this._gridSize + offsetSize)))
               {
                  this._data[i][j] = false;
               }
               else
               {
                  this._data[i][j] = true;
                  this._allowData.push(new Point(i * this._gridSize,j * this._gridSize));
               }
            }
         }
         p = null;
         _hitBMD.dispose();
         _hitBMD = null;
      }
      
      private function loadMap(isShowLoading:Boolean) : void
      {
         var type:int = 0;
         if(this._loader == null)
         {
            if(MainManager.actorInfo.mapID <= 9 && this._id > 9 && this._id < 100)
            {
               if(isShowLoading)
               {
                  type = Loading.TITLE_AND_PERCENT;
               }
               else
               {
                  type = Loading.NO_ALL;
               }
               this._loader = new MCLoader("",LevelManager.topLevel,type,"加载地图",false);
            }
            else
            {
               if(isShowLoading)
               {
                  type = Loading.TITLE_AND_PERCENT;
               }
               else
               {
                  type = Loading.NO_ALL;
               }
               this._loader = new MCLoader("",LevelManager.topLevel,type,"加载地图",false);
            }
         }
         this._loader.setIsShowClose(this._isCanClose);
         this._loader.addEventListener(MCLoadEvent.SUCCESS,this.onMapComplete);
         this._loader.addEventListener(MCLoadEvent.ERROR,this.onMapError);
         this._loader.addEventListener(MCLoadEvent.CLOSE,this.onMapClose);
         this._loader.doLoad(ClientConfig.getMapPath(MapManager.getResMapID(this._id)));
         trace("load map:",ClientConfig.getMapPath(MapManager.getResMapID(this._id)));
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_LOADER_OPEN));
      }
      
      private function onMapComplete(e:MCLoadEvent) : void
      {
         var titleMc:DisplayObject = null;
         this._loader.removeEventListener(MCLoadEvent.SUCCESS,this.onMapComplete);
         this._loader.removeEventListener(MCLoadEvent.ERROR,this.onMapError);
         this._loader.removeEventListener(MCLoadEvent.CLOSE,this.onMapClose);
         MapLibManager.setup(e.getLoader());
         this._root = e.getContent().root as DisplayObjectContainer;
         this._depthLevel = this._root["depth_mc"];
         this._typeLevel = this._root["type_mc"];
         this._topLevel = this._root["top_mc"];
         this._controlLevel = this._root["control_mc"];
         this._btnLevel = this._root["buttonLevel"];
         this._animatorLevel = this._root["animator_mc"];
         var mc:Sprite = this._root["rect_mc"];
         if(Boolean(mc))
         {
            this._spaceLevel = mc;
            this._spaceLevel.alpha = 0;
         }
         else
         {
            this._spaceLevel = this.creatRect();
         }
         this._backLevel = this.creatBitmap(this._root["bg_mc"]);
         this._root.addChildAt(this._backLevel,0);
         this._root.addChildAt(this._spaceLevel,1);
         if(Boolean(this._animatorLevel))
         {
            this._animatorLevel.mouseEnabled = false;
            this._animatorLevel.mouseChildren = false;
         }
         if(MapController.isReMap)
         {
            titleMc = this._topLevel["title_mc"];
            if(Boolean(titleMc))
            {
               DisplayUtil.removeForParent(titleMc);
            }
         }
         this._spaceLevel.mouseChildren = false;
         this._depthLevel.mouseEnabled = false;
         this._controlLevel.mouseEnabled = false;
         this._btnLevel.mouseEnabled = false;
         this._typeLevel.mouseChildren = false;
         this._typeLevel.mouseEnabled = false;
         this._topLevel.mouseEnabled = false;
         this._gridX = int(this.width / this._gridSize);
         this._gridY = int(this.height / this._gridSize);
         this._gridTotal = this._gridX * this._gridY;
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_LOADER_COMPLETE));
         this.initFindPath();
      }
      
      private function onMapClose(e:MCLoadEvent) : void
      {
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_LOADER_CLOSE));
      }
      
      private function onMapError(e:MCLoadEvent) : void
      {
         trace("地图加载失败",e.toString());
         this._loader.removeEventListener(MCLoadEvent.SUCCESS,this.onMapComplete);
         this._loader.removeEventListener(MCLoadEvent.ERROR,this.onMapError);
         this._loader.removeEventListener(MCLoadEvent.CLOSE,this.onMapClose);
         this._loader.clear();
         this._loader = null;
         MapManager.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      private function initFindPath() : void
      {
         this._timeoutID = setTimeout(this.onMakMap,200);
      }
      
      private function onMakMap() : void
      {
         if(this._timeoutID != 0)
         {
            clearTimeout(this._timeoutID);
         }
         this.makeMapArray();
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_INIT));
      }
      
      private function creatRect() : Sprite
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(0,0);
         sp.graphics.drawRect(0,0,this._width,this._height);
         sp.graphics.endFill();
         return sp;
      }
      
      private function creatBitmap(dis:DisplayObjectContainer) : Bitmap
      {
         var bm:Bitmap = new Bitmap();
         var bd:BitmapData = new BitmapData(this.width,this.height);
         bd.draw(dis);
         bm.bitmapData = bd;
         DisplayUtil.removeForParent(dis);
         return bm;
      }
   }
}

