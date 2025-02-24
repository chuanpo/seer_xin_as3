package org.taomee.ds
{
   public class TreeSet implements ITree
   {
      private var _root:TreeSet;
      
      private var _data:*;
      
      private var _parent:TreeSet;
      
      private var _children:HashSet;
      
      public function TreeSet(data:* = null, parent:TreeSet = null)
      {
         super();
         _data = data;
         _children = new HashSet();
         this.parent = parent;
      }
      
      public function get depth() : int
      {
         if(!_parent)
         {
            return 0;
         }
         var node:TreeSet = _parent;
         var c:int = 0;
         while(Boolean(node))
         {
            c++;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeSet Infinite Loop");
            }
         }
         return c;
      }
      
      public function remove() : void
      {
         if(_parent == null)
         {
            return;
         }
         _children.each2(function(child:TreeSet):void
         {
            child.parent = _parent;
         });
      }
      
      public function clear() : void
      {
         _children = new HashSet();
      }
      
      public function set data(d:*) : void
      {
         _data = d;
      }
      
      public function get numSiblings() : int
      {
         if(Boolean(_parent))
         {
            return _parent.numChildren;
         }
         return 0;
      }
      
      public function get root() : TreeSet
      {
         return _root;
      }
      
      public function set parent(parent:TreeSet) : void
      {
         if(Boolean(_parent))
         {
            _parent.children.remove(this);
         }
         if(parent == this)
         {
            return;
         }
         _parent = parent;
         if(Boolean(_parent))
         {
            _parent.children.add(this);
         }
         setRoot();
      }
      
      private function setRoot() : void
      {
         if(_parent == null)
         {
            _root = this;
            return;
         }
         var node:TreeSet = _parent;
         while(Boolean(node))
         {
            if(node.parent == null)
            {
               _root = node;
               return;
            }
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeSet Infinite Loop");
            }
         }
      }
      
      public function get length() : int
      {
         var c:int = numChildren;
         var node:TreeSet = _parent;
         while(Boolean(node))
         {
            c += node.numChildren;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeSet Infinite Loop");
            }
         }
         return c;
      }
      
      public function get isLeaf() : Boolean
      {
         return _children.length == 0;
      }
      
      public function get data() : *
      {
         return _data;
      }
      
      public function get isRoot() : Boolean
      {
         return _root == this;
      }
      
      public function get numChildren() : int
      {
         return _children.length;
      }
      
      public function get parent() : TreeSet
      {
         return _parent;
      }
      
      public function get children() : HashSet
      {
         return _children;
      }
   }
}

