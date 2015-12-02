import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/bootstrap.dart';

@Component(selector: 'article-list')
@View(
    template: '''
<h1>Articles</h1>
<ul>
<li><a [router-link]="[ '/Article/View', {articleId: 'article1'} ]">Article 1</a>
<!-- <li><a (click)="onClick()">Article 1</a> -->
</ul>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleList {
  Router router;
  ArticleList(this.router);
  onClick() {
//    router.navigateByUrl('/article/article1/view');
    var inst = router.generate([
      '/Article/View',
      {'articleId': 'article1'}
    ]);
    print(inst.component.params);
    print(inst.component.urlParams);
    print(inst.component.urlPath);
//    router.navigate([
//      '/Article/View',
//      {'articleId': 'article1'}
//    ]);
  }
}

//
//
//

@Component(selector: 'article-editor')
@View(
    template: '''
<h1>Article Editor</h1>
<a [router-link]="[ '/Article/View', {articleId: routeParams.get('articleId')} ]">View</a>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleEditor {
  final RouteParams routeParams;
  ArticleEditor(this.routeParams);
}

@Component(selector: 'article-view')
@View(
    template: '''
<h1>Article View</h1>
<a [router-link]="[ '/Article/Edit', {articleId: routeParams.get('articleId')} ]">Edit</a>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleView {
  final RouteParams routeParams;
  ArticleView(this.routeParams);
}

@Component(selector: 'article')
@View(
    template: '''
<h1>Article</h1>
<a [router-link]="[ '/ArticleList' ]">View All</a>
<router-outlet></router-outlet>
''',
    directives: const [ROUTER_DIRECTIVES])
@RouteConfig(const [
  const Route(path: '/:articleId/edit', name: 'Edit', component: ArticleEditor),
  const Route(path: '/:articleId/view', name: 'View', component: ArticleView)
])
class Article {}

//
//
//

@Component(selector: 'my-app')
@View(
    template: '''
<div>
  <base href="/">
  <router-outlet></router-outlet>
</div>
''',
    directives: const [ROUTER_DIRECTIVES])
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: '/articles'),
  const Route(path: '/articles', name: 'ArticleList', component: ArticleList),
  const Route(path: '/article/...', name: 'Article', component: Article),
//  const Route(
//      path: '/article/:articleId/...', name: 'Article', component: Article)
])
class Index {
  Router router;

  Index(Router this.router);
}

//
//
//

main() {
  bootstrap(Index, [
    ROUTER_PROVIDERS
//    , provide(APP_BASE_HREF, useValue: '/')
//    provide(LocationStrategy, useClass: HashLocationStrategy)
  ]);
}
