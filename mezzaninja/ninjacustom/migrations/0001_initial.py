# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'LinksPage'
        db.create_table('ninjacustom_linkspage', (
            ('page_ptr', self.gf('django.db.models.fields.related.OneToOneField')(to=orm['pages.Page'], unique=True, primary_key=True)),
            ('content', self.gf('mezzanine.core.fields.RichTextField')()),
        ))
        db.send_create_signal('ninjacustom', ['LinksPage'])

        # Adding model 'DownloadLink'
        db.create_table('ninjacustom_downloadlink', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('_order', self.gf('django.db.models.fields.IntegerField')(null=True)),
            ('page', self.gf('django.db.models.fields.related.ForeignKey')(related_name='download_links', to=orm['ninjacustom.LinksPage'])),
            ('link', self.gf('django.db.models.fields.URLField')(max_length=200)),
            ('version', self.gf('django.db.models.fields.CharField')(max_length=20, blank=True)),
            ('os', self.gf('django.db.models.fields.CharField')(max_length=10)),
            ('distribution', self.gf('django.db.models.fields.CharField')(max_length=80, blank=True)),
            ('extra_detail', self.gf('django.db.models.fields.CharField')(max_length=800, blank=True)),
        ))
        db.send_create_signal('ninjacustom', ['DownloadLink'])

        # Adding model 'TeamPage'
        db.create_table('ninjacustom_teampage', (
            ('page_ptr', self.gf('django.db.models.fields.related.OneToOneField')(to=orm['pages.Page'], unique=True, primary_key=True)),
            ('content', self.gf('mezzanine.core.fields.RichTextField')()),
        ))
        db.send_create_signal('ninjacustom', ['TeamPage'])

        # Adding model 'TeamMember'
        db.create_table('ninjacustom_teammember', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('_order', self.gf('django.db.models.fields.IntegerField')(null=True)),
            ('page', self.gf('django.db.models.fields.related.ForeignKey')(related_name='team_members', to=orm['ninjacustom.TeamPage'])),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=200)),
            ('irc_nickname', self.gf('django.db.models.fields.CharField')(max_length=200)),
            ('twitter', self.gf('django.db.models.fields.CharField')(max_length=300, blank=True)),
            ('email', self.gf('django.db.models.fields.EmailField')(max_length=200, blank=True)),
            ('detail', self.gf('django.db.models.fields.TextField')(blank=True)),
            ('web', self.gf('django.db.models.fields.URLField')(max_length=200, blank=True)),
        ))
        db.send_create_signal('ninjacustom', ['TeamMember'])


    def backwards(self, orm):
        # Deleting model 'LinksPage'
        db.delete_table('ninjacustom_linkspage')

        # Deleting model 'DownloadLink'
        db.delete_table('ninjacustom_downloadlink')

        # Deleting model 'TeamPage'
        db.delete_table('ninjacustom_teampage')

        # Deleting model 'TeamMember'
        db.delete_table('ninjacustom_teammember')


    models = {
        'ninjacustom.downloadlink': {
            'Meta': {'ordering': "(u'_order',)", 'object_name': 'DownloadLink'},
            '_order': ('django.db.models.fields.IntegerField', [], {'null': 'True'}),
            'distribution': ('django.db.models.fields.CharField', [], {'max_length': '80', 'blank': 'True'}),
            'extra_detail': ('django.db.models.fields.CharField', [], {'max_length': '800', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'os': ('django.db.models.fields.CharField', [], {'max_length': '10'}),
            'page': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'download_links'", 'to': "orm['ninjacustom.LinksPage']"}),
            'version': ('django.db.models.fields.CharField', [], {'max_length': '20', 'blank': 'True'})
        },
        'ninjacustom.linkspage': {
            'Meta': {'ordering': "(u'_order',)", 'object_name': 'LinksPage', '_ormbases': ['pages.Page']},
            'content': ('mezzanine.core.fields.RichTextField', [], {}),
            'page_ptr': ('django.db.models.fields.related.OneToOneField', [], {'to': "orm['pages.Page']", 'unique': 'True', 'primary_key': 'True'})
        },
        'ninjacustom.teammember': {
            'Meta': {'ordering': "(u'_order',)", 'object_name': 'TeamMember'},
            '_order': ('django.db.models.fields.IntegerField', [], {'null': 'True'}),
            'detail': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '200', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'irc_nickname': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'page': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'team_members'", 'to': "orm['ninjacustom.TeamPage']"}),
            'twitter': ('django.db.models.fields.CharField', [], {'max_length': '300', 'blank': 'True'}),
            'web': ('django.db.models.fields.URLField', [], {'max_length': '200', 'blank': 'True'})
        },
        'ninjacustom.teampage': {
            'Meta': {'ordering': "(u'_order',)", 'object_name': 'TeamPage', '_ormbases': ['pages.Page']},
            'content': ('mezzanine.core.fields.RichTextField', [], {}),
            'page_ptr': ('django.db.models.fields.related.OneToOneField', [], {'to': "orm['pages.Page']", 'unique': 'True', 'primary_key': 'True'})
        },
        'pages.page': {
            'Meta': {'ordering': "(u'titles',)", 'object_name': 'Page'},
            '_meta_title': ('django.db.models.fields.CharField', [], {'max_length': '500', 'null': 'True', 'blank': 'True'}),
            '_order': ('django.db.models.fields.IntegerField', [], {'null': 'True'}),
            'content_model': ('django.db.models.fields.CharField', [], {'max_length': '50', 'null': 'True'}),
            'created': ('django.db.models.fields.DateTimeField', [], {'null': 'True'}),
            'description': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'expiry_date': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'gen_description': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'in_menus': ('mezzanine.pages.fields.MenusField', [], {'default': '(1, 2, 3)', 'max_length': '100', 'null': 'True', 'blank': 'True'}),
            'in_sitemap': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'keywords_string': ('django.db.models.fields.CharField', [], {'max_length': '500', 'blank': 'True'}),
            'login_required': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'parent': ('django.db.models.fields.related.ForeignKey', [], {'blank': 'True', 'related_name': "u'children'", 'null': 'True', 'to': "orm['pages.Page']"}),
            'publish_date': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'short_url': ('django.db.models.fields.URLField', [], {'max_length': '200', 'null': 'True', 'blank': 'True'}),
            'site': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['sites.Site']"}),
            'slug': ('django.db.models.fields.CharField', [], {'max_length': '2000', 'null': 'True', 'blank': 'True'}),
            'status': ('django.db.models.fields.IntegerField', [], {'default': '2'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '500'}),
            'titles': ('django.db.models.fields.CharField', [], {'max_length': '1000', 'null': 'True'}),
            'updated': ('django.db.models.fields.DateTimeField', [], {'null': 'True'})
        },
        'sites.site': {
            'Meta': {'ordering': "(u'domain',)", 'object_name': 'Site', 'db_table': "u'django_site'"},
            'domain': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        }
    }

    complete_apps = ['ninjacustom']