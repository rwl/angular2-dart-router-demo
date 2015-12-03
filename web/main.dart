import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/bootstrap.dart';

@Component(selector: 'article-editor')
@View(
    template: '''
<h1>Article Editor</h1>
<a [router-link]="[ '/Article', {articleId: id}, 'View', {articleId: id} ]">View</a>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleEditor {
  String id;
  ArticleEditor(RouteParams routeParams) : id = routeParams.get('articleId');
}

@Component(selector: 'article-view')
@View(
    template: '''
<h1>Article View</h1>
<a [router-link]="[ '/Article', {articleId: id}, 'Edit', {articleId: id} ]">Edit</a>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleView implements AfterViewInit {
  Router router;
  String id;
  ArticleView(this.router, RouteParams routeParams)
      : id = routeParams.get('articleId');

  ngAfterViewInit() {
    var inst = router.generate([
      '/Article',
      {'articleId': id},
      'View',
      {'articleId': id}
    ]);
    print(
        'ArticleView.ngAfterViewInit: ${router.navigating} ${router.isRouteActive(inst)}');
  }
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
  const Route(path: '/edit/:articleId', name: 'Edit', component: ArticleEditor),
  const Route(path: '/view/:articleId', name: 'View', component: ArticleView)
])
class Article implements OnActivate {
  Router router;
  String id;
  Article(this.router, RouteParams params) : id = params.get('articleId') {
    print(params.params);
  }

  ngAfterViewInit() {
    var view = router.generate([
      './View',
      {'articleId': id}
    ]);
    print(
        'Article.ngAfterViewInit: ${router.navigating} ${router.isRouteActive(view)}');

    var edit = router.generate([
      '/Article',
      {'articleId': id},
      'Edit',
      {'articleId': id}
    ]);
    print('Article: ${router.navigating} ${router.isRouteActive(edit)}');
  }

  routerOnActivate(ComponentInstruction next, ComponentInstruction prev) {
//    print('Article.routerOnActivate: ${next.componentType == Article}');
//    print('Article.routerOnActivate: ${next.componentType == ArticleView}');
  }
}

//
//
//

@Component(selector: 'article-list')
@View(
    template: '''
<h1>Articles</h1>
<ul>
<li><a [router-link]="[ '/Article', {articleId: selectedId}, 'View', {articleId: selectedId} ]">Article 1</a>
</ul>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleList implements AfterViewInit, OnActivate {
  Router router;
  String selectedId = 'article1';
  ArticleList(this.router);

  ngAfterViewInit() {}

  routerOnActivate(ComponentInstruction next, ComponentInstruction prev) {
//    print('ArticleList.routerOnActivate: ${next.componentType == ArticleList}');

    var inst = router.generate(['/ArticleList']);
    print(
        'ArticleList.routerOnActivate: ${router.navigating} ${router.isRouteActive(inst)}');
  }
}

//
//
//

@Component(selector: 'my-app')
@View(
    template: '''
<base href="/">
<router-outlet></router-outlet>
''',
    directives: const [ROUTER_DIRECTIVES])
@RouteConfig(const [
  const Redirect(path: '/', redirectTo: const ['ArticleList']),
  const Route(path: '/articles', name: 'ArticleList', component: ArticleList),
  const Route(
      path: '/article/:articleId/...', name: 'Article', component: Article)
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
    ROUTER_PROVIDERS,
//    , provide(APP_BASE_HREF, useValue: '/')
    provide(LocationStrategy, useClass: HashLocationStrategy)
  ]);
}
