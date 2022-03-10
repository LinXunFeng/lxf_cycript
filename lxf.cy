(function(exports) {
  // bundle id
  exports.appId = function() {
    return NSBundle.mainBundle.bundleIdentifier;
  }

  // main bundle path
  exports.appPath = function() {
    return NSBundle.mainBundle.bundlePath;
  }

  // document path
	exports.documentPath = function() {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  }

	// caches path
	exports.cachesPath = function() {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
  }

  // keyWindows
  exports.keyWindow = function() {
    return UIApp.keyWindow;
  }

  // 打印所有的视图
  exports.subViews = function() {
    return [[UIApp keyWindow] recursiveDescription].toString();
  }

  // 打印所有的视图(subViews的简洁版)
  exports.subViewsSimple = function() {
    return [[UIApp keyWindow] recursiveDescription].toString();
  }

  // 根控制器
  exports.rootVc = function() {
    return UIApp.keyWindow.rootViewController;
  }

  // 查找指定视图的控制器
  exports.findVc = function(view) {
    var curView = view;
    while ([curView isKindOfClass:[NSClassFromString(@"UIViewController")]]!= true) {
      curView = curView.nextResponder;
    }
    return curView;
  }

  function _topVc(vc) {
    if (vc.presentedViewController) {
      return _topVc(vc.presentedViewController);
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return _topVc(vc.selectedViewController);
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        return _topVc(vc.visibleViewController);
    } else {
      var count = vc.childViewControllers.count;
      for (var i = count - 1; i >= 0; i--) {
        var childVc = vc.childViewControllers[i];
        if (childVc && childVc.view.window) {
          vc = _topVc(childVc);
          break;
        }
      }
      return vc;
    }
  }

  // 获取当前最顶层的控制器
  exports.topVc = function() {
    return _topVc(exports.rootVc());
  }

  // 打印对象的所有属性
  exports.printIvars = function(obj) {
    var ivars = {};
    for (i in *obj) {
      try {
        ivars[i] = (*obj)[i];
      } catch (e) {}
    }
    return ivars;
  }

  // 打印所有的成员变量
  exports.ivars = function(obj, reg) {
    if (!obj) throw new Error(missingParamStr);
		var x = {}; 
		for(var i in *obj) { 
			try { 
				var value = (*obj)[i];
				if (reg && !reg.test(i) && !reg.test(value)) continue;
				x[i] = value; 
			} catch(e){} 
		} 
		return x; 
  }

  // 打印所有的成员变量名字
  exports.ivarNames = function(obj, reg) {
    if (!obj) throw new Error(missingParamStr);
		var array = [];
		for(var name in *obj) { 
			if (reg && !reg.test(name)) continue;
			array.push(name);
		}
		return array;
  }

	// 判断是否为字符串
	exports.isString = function(str) {
		return typeof str == 'string' || str instanceof String;
	};

  function _class(className) {
		if (!className) throw new Error(missingParamStr);
		if (exports.isString(className)) {
			return NSClassFromString(className);
		} 
		if (!className) throw new Error(invalidParamStr);
		// 对象或者类
		return className.class();
	};
  
	// 打印所有的方法
	function _getMethods(className, reg, clazz) {
		className = _class(className);

		var count = new new Type('I');
		var classObj = clazz ? className.constructor : className;
		var methodList = class_copyMethodList(classObj, count);
		var methodsArray = [];
		var methodNamesArray = [];
		for(var i = 0; i < *count; i++) {
			var method = methodList[i];
			var selector = method_getName(method);
			var name = sel_getName(selector);
			if (reg && !reg.test(name)) continue;
			methodsArray.push({
				selector : selector, 
				type : method_getTypeEncoding(method)
			});
			methodNamesArray.push(name);
		}
		free(methodList);
		return [methodsArray, methodNamesArray];
	};

	function _methods(className, reg, clazz) {
		return _getMethods(className, reg, clazz)[0];
	};

	// 打印所有的方法名字
	function _methodNames(className, reg, clazz) {
		return _getMethods(className, reg, clazz)[1];
	};

	// 打印所有的对象方法
	exports.methods = function(className, reg) {
		return _methods(className, reg);
	};

	// 打印所有的对象方法名字
	exports.methodNames = function(className, reg) {
		return _methodNames(className, reg);
	};

	// 打印所有的类方法
	exports.classMethods = function(className, reg) {
		return _methods(className, reg, true);
	};

	// 打印所有的类方法名字
	exports.classMethodNames = function(className, reg) {
		return _methodNames(className, reg, true);
	};

	// 加载系统动态库
	exports.loadFramework = function(name) {
		var head = "/System/Library/";
		var foot = "Frameworks/" + name + ".framework";
		var bundle = [NSBundle bundleWithPath:head + foot] || [NSBundle bundleWithPath:head + "Private" + foot];
  		[bundle load];
  		return bundle;
	};
  
})(exports);