import 'package:flutter/material.dart';
import 'package:phoenix_base/phoenix.dart';
import 'package:phoenix_dialog/phoenix_dialog.dart';

/// 页面或者弹窗中间的圆形加载框，左侧是可定制的加载文案[content]，比如：加载中、提交中等等
///
/// 该组件 并不支持获取 指定时刻的动画值
///
/// 页面中使用
/// Scaffold(
///   appBar: BrnAppBar(
///      title: 'Loading案例',
///   ),
///   body: BrnPageLoading(),
/// )
///
/// 对话框中使用
/// showDialog(
///    context: context,
///    barrierDismissible: barrierDismissible,
///    useRootNavigator: useRootNavigator,
///    builder: (_) {
///       return BrnLoadingDialog(content: content);
///    });
///
/// 其他加载组件:
///  * [LinearProgressIndicator], 线性加载组件.
///  * [RefreshIndicator], 刷新组件。
///  * [BrnLoadingDialog], 加载对话框。

class PageLoading extends StatelessWidget {
  final String? content;
  final BoxConstraints constraints;

  const PageLoading({
    Key? key,
    this.content,
    this.constraints = const BoxConstraints(
      minWidth: 130,
      maxWidth: 130,
      minHeight: 50,
      maxHeight: 50,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double loadingMaxWidth = MediaQuery.of(context).size.width * 2 / 3;
    double iconSize = 19.0;
    double textLeftPadding = 8.0;
    double outPadding = 10.0;
    String loadingText =
        content ?? BrnIntl.of(context).localizedResource.loading;
    // 获取实际文字长度
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(
          text: loadingText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              decoration: TextDecoration.none)),
    )..layout(
        maxWidth: loadingMaxWidth - iconSize - textLeftPadding, minWidth: 0);
    double maxWidth =
        textPainter.width + iconSize + textLeftPadding + outPadding * 2;

    return Center(
      child: Container(
        padding: EdgeInsets.all(outPadding),
        constraints: BoxConstraints(
            maxWidth: maxWidth, minWidth: iconSize + textLeftPadding),
        height: 50,
        width: loadingMaxWidth,
        decoration: BoxDecoration(
            color: const Color(0xff222222),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: iconSize,
                width: iconSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: textLeftPadding),
                  child: Text(
                    loadingText,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 通过 [BrnPageLoading] 构建出的加载状态的弹窗，加载动画和加载文字并排展示，且在屏幕中间。可通
/// 过 [BrnLoadingDialog.show] 和 [BrnLoadingDialog.dismiss] 控制弹窗的显示和关闭。不会自动关闭。
class LoadingDialog extends Dialog {
  /// tag 用于在 BrnSafeDialog 中标记类型
  static const String _loadingDialogTag = '_loadingDialogTag';

  /// 加载时的提示文案，默认为 `加载中...`
  final String? content;

  const LoadingDialog({Key? key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageLoading(
        content: content ?? BrnIntl.of(context).localizedResource.loading);
  }

  /// 展示加载弹窗的静态方法。
  ///
  ///  * [context] 上下文
  ///  * [content] 加载时的提示文案
  ///  * [barrierDismissible] 点击蒙层背景是否关闭弹窗，默认为 true，可关闭，详见 [showDialog] 中的 [barrierDismissible]
  ///  * [useRootNavigator] 把弹窗添加到 [context] 中的 rootNavigator 还是最近的 [Navigator]，默认为 true，添加到
  ///    rootNavigator，详见 [showDialog] 中的 [useRootNavigator]。
  static Future<T?> show<T>(
    BuildContext context, {
    String? content,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    return SafeDialog.show<T>(
        context: context,
        tag: _loadingDialogTag,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return LoadingDialog(
              content:
                  content ?? BrnIntl.of(context).localizedResource.loading);
        });
  }

  /// 关闭弹窗。
  ///
  ///  * [context] 上下文。
  static void dismiss<T extends Object?>(BuildContext context, [T? result]) {
    SafeDialog.dismiss<T>(
        context: context, tag: _loadingDialogTag, result: result);
  }
}
