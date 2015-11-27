import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/bootstrap.dart';

@Component(selector: 'article-list')
@View(
    template: '''
<h1>Articles</h1>
<ul>
<li><a [router-link]="[ '/Article', {articleId: 'article1'} ]">Article 1</a>
</ul>
''',
    directives: const [ROUTER_DIRECTIVES])
class ArticleList {}

//
//
//

@Component(selector: 'article')
@View(
    template: '''
<h1>Article</h1>
<a [router-link]="[ '/ArticleList' ]">View All</a>
''',
    directives: const [ROUTER_DIRECTIVES])
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
  const Route(path: '/:articleId', name: 'Article', component: Article)
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
//    provide(LocationStrategy, useClass: HashLocationStrategy)
  ]);
}
