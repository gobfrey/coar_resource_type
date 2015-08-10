#feel free to override this in an alphbetically later .pl file
$c->{coar_resource_type_label_lang} = 'en';

foreach my $field (
	{
		name => 'coar_resource_type_uri',
		type => 'text',
		volatile => 1,
	},
	{
		name => 'coar_resource_type_label',
		type => 'text',
		volatile => 1,
	}
)
{
	$c->add_dataset_field('eprint', $field);
};

$c->{set_eprint_automatic_fields_coar_resource_type} = $c->{set_eprint_automatic_fields};
$c->{set_eprint_automatic_fields} = sub
{
	my ($eprint) = @_;
	my $repo = $eprint->repository;
	my $type = $eprint->value('type');

	#call original automatic fields function
	$repo->call('set_eprint_automatic_fields_coar_resource_type', $eprint);

	#simple lookup
	my $coar_type = $repo->config('coar_resource_type_type_map', $type);

	#more complex stuff
	if ($type eq 'monograph')
	{
		$coar_type = $repo->config('coar_resource_type_monograph_type_map', $eprint->value('monograph_type'));
	}

	#you can create a function in a .pl file to return a coar_type if you want to do anything fancy
	if ($repo->can_call('coar_resource_type_local_fn'))
	{
		$coar_type = $repo->call('coar_resource_type_local_fn', $eprint);
	}

	my ($name, $uri);
	if ($repo->config('coar_resource_type_vocabulary', $coar_type))
	{
		$uri = $repo->config('coar_resource_type_vocabulary', $coar_type, 'uri');
		$name = $repo->config('coar_resource_type_vocabulary', $coar_type, 'labels', $repo->config('coar_resource_type_label_lang'));
	}
	$eprint->set_value('coar_resource_type_uri', $uri);
	$eprint->set_value('coar_resource_type_label', $name);
};

#map eprint type to resource type
#to change, override in an alphabetically later .pl file
#e.g. $c->{coar_resource_type_type_map}->{book} = 'abc123';
$c->{coar_resource_type_type_map} = 
{
	'article' => 'c_6501', #journal article
	'book_section' => 'c_3248', #book part
	'monograph' => '', #use monograph_type to decide 
	'conference_item' => 'c_c94f', #conference object
	'book' => 'c_2f33', #book
	'thesis' => 'c_46ec', #thesis
	'patent' => 'c_15cd', #patent
	'artefact' => 'c_1843', #other
	'exhibition' => 'c_1843', #other
	'composition' => 'c_18cd', #musical composition
	'performance' => 'c_1843', #other
	'image' => 'c_ecc8', #still image
	'video' => 'c_12ce', #video
	'audio' => 'c_18cc', #sound
	'dataset' => 'c_ddb1', #dataset
	'experiment' => 'c_1843', #other
	'teaching_resource' => 'c_1843', #other
	'other' => 'c_1843', #other
};

#to change, override in an alphabetically later .pl file
#e.g. $c->{coar_resource_type_monograph_type_map}->{book} = 'abc123';
$c->{coar_resource_type_monograph_type_map} =
{
	'technical_report' => 'c_18gh', #technical report
	'project_report' => 'c_18op', #project deliverable
	'documentation' => 'c_71bd', #technical documentation
	'manual' => 'c_71bd', #technical documentation
	'working_paper' => 'c_8042', #working paper
	'discussion_paper' => 'c_8042', #working paper
	'other' => 'c_18wq', #other type of report
};


{
	use utf8;
	$c->{coar_resource_type_vocabulary} = 
	{
		c_1162 =>
		{
			uri => 'http://purl.org/coar/resource_type/c_1162',
			labels =>
			{
				en => 'annotation',
				zh => '标注',
				es => 'comentario',
				ru => 'примечание',
				it => 'commento',
				de => 'Entscheidungs- oder Urteilsanmerkung',
				ca => 'anotació',
				pt => 'anotação',
				fr => 'annotation',
			}
		},
		c_2659 => {
			uri => 'http://purl.org/coar/resource_type/c_2659',
			labels =>
			{
				en => 'periodical',
				zh => '期刊',
				es => 'publicación periódica',
				ru => 'периодическое издание',
				ca => 'publicació en sèrie',
				it => 'periodico',
				pt => 'publicação periódica',
				de => 'Periodikum',
				fr => 'périodique',
			}
		},
		c_0640 => {
			uri => 'http://purl.org/coar/resource_type/c_0640',
			labels =>
			{
				en => 'journal',
				zh => '学术期刊',
				es => 'revista',
				ru => 'журнал',
				fr => 'revue',
				it => 'rivista',
				ca => 'revista',
				pt => 'revista',
				de => 'Zeitschrift',
			}
		},
		c_6501 => {
			uri => 'http://purl.org/coar/resource_type/c_6501',
			labels =>
			{
				en => 'journal article',
				zh => '学术论文',
				es => 'artículo',
				it => 'articolo in rivista',
				fr => 'article',
				de => 'Wissenschaftlicher Artikel',
				ru => 'журнальная статья',
				ca => 'article de revista',
				pt => 'artigo',
			}
		},
		c_b239 => {
			uri => 'http://purl.org/coar/resource_type/c_b239',
			labels =>
			{
				en => 'editorial',
				zh => '社论',
				es => 'editorial',
				it => 'editoriale',
				ru => 'редакционная статья',
				ca => 'editorial de revista',
				pt => 'editorial',
				de => 'Vorwort',
				fr => 'éditorial',
			}
		},
		c_7a1f => {
			uri => 'http://purl.org/coar/resource_type/c_7a1f',
			labels =>
			{
				en => 'bachelor thesis',
				zh => '学士学位论文',
				es => 'proyecto fin de carrera',
				it => 'tesi di laurea',
				ru => 'диплом бакалавра',
				de => 'Abschlussarbeit (Bachelor)',
				ca => 'project final de carrera',
				pt => 'trabalho de fim de curso',
				fr => 'mémoire de stage',
			}
		},
		c_86bc => {
			uri => 'http://purl.org/coar/resource_type/c_86bc',
			labels =>
			{
				en => 'bibliography',
				zh => '文献目录',
				es => 'bibliografía',
				it => 'bibliografia',
				ru => 'библиография',
				fr => 'bibliographie',
				ca => 'bibliografia',
				pt => 'bibliografia',
				de => 'Bibliografie',
			}
		},
		c_2f33 => {
			uri => 'http://purl.org/coar/resource_type/c_2f33',
			labels =>
			{
				en => 'book',
				zh => '书',
				es => 'libro',
				it => 'libro',
				pt => 'livro',
				ru => 'книга',
				fr => 'ouvrage',
				de => 'Buch',
				ca => 'llibre',
			}
		},
		c_3248 => {
			uri => 'http://purl.org/coar/resource_type/c_3248',
			labels =>
			{
				en => 'book part',
				zh => '章节',
				es => 'capítulo de libro',
				pt => 'capítulo de livro',
				it => 'capitolo di libro',
				fr => "chapitre d'ouvrage",
				de => 'Teil oder Kapitel eines Buches',
				ru => 'раздел книги ',
				ca => 'part de llibre',
			}
		},
		c_efa0 => {
			uri => 'http://purl.org/coar/resource_type/c_efa0',
			labels =>
			{
				en => 'review',
				zh => '评论',
				es => 'reseña',
				ru => 'рецензия',
				it => 'recensione',
				de => 'Rezension',
				ca => 'ressenya ',
				pt => 'recensão',
				fr => 'synthèse',
			}
		},
		c_ba08 => {
			uri => 'http://purl.org/coar/resource_type/c_ba08',
			labels =>
			{
				en => 'book review',
				zh => '书评',
				es => 'reseña de libro',
				fr => 'note de lecture',
				it => 'recensione di libro',
				de => 'Buchrezension',
				ru => 'рецензия на книгу',
				ca => 'ressenya de llibre',
				pt => 'recensão de livro',
			}
		},
		c_7ad9 => {
			uri => 'http://purl.org/coar/resource_type/c_7ad9',
			labels =>
			{
				en => 'website',
				zh => '网站',
				es => 'sitio web',
				it => 'sito web',
				ru => 'веб-сайт',
				ca => 'lloc web',
				pt => 'sítio web',
				de => 'Webseite',
				fr => 'site web',
			}
		},
		c_e9a0 => {
			uri => 'http://purl.org/coar/resource_type/c_e9a0',
			labels =>
			{
				en => 'interactive resource',
				zh => '互动资源',
				es => 'recurso interactivo',
				ru => 'интерактивный ресурс',
				ca => 'recurs interactiu',
				it => 'risorsa interattiva',
				pt => 'recurso interativo',
				de => 'interaktive Ressource',
				fr => 'ressource interactive',
			}
		},
		c_f744 => {
			uri => 'http://purl.org/coar/resource_type/c_f744',
			labels =>
			{
				en => 'conference proceedings',
				zh => '会议论文集',
				ru => 'сборник материалов конференции',
				ca => 'actes de congrés',
				es => 'actas de congreso',
				it => 'atti di congresso',
				pt => 'atas de conferência',
				de => 'Tagungsband',
				fr => 'actes de conférence',
			}
		},
		c_c94f => {
			uri => 'http://purl.org/coar/resource_type/c_c94f',
			labels =>
			{
				en => 'conference object',
				zh => '会议文档',
				es => 'contribución a congreso',
				ru => 'материалы конференции',
				ca => 'contribució a congrés',
				it => 'contributo a congresso',
				pt => 'documento de conferência',
				de => 'Konferenzveröffentlichung',
				fr => 'contribution à une conférence',
			}
		},
		c_5794 => {
			uri => 'http://purl.org/coar/resource_type/c_5794',
			labels =>
			{
				en => 'conference paper',
				zh => '会议论文',
				es => 'comunicación de congreso',
				it => 'comunicazione a congresso',
				ca => 'comunicació de congrés',
				pt => 'comunicação em conferência',
				de => 'Konferenzbeitrag',
				fr => 'article dans une conférence',
				ru => 'статья для конференции',
			}
		},
		c_6670 => {
			uri => 'http://purl.org/coar/resource_type/c_6670',
			labels =>
			{
				en => 'conference poster',
				zh => '会议海报',
				es => 'póster de congreso',
				it => 'poster in congresso',
				ca => 'poster de congrés',
				pt => 'póster em conferência ',
				de => 'Konferenzposter',
				fr => 'poster dans une conférence',
				ru => 'постер конференции',
			}
		},
		c_3e5a => {
			uri => 'http://purl.org/coar/resource_type/c_3e5a',
			labels =>
			{
				en => 'contribution to journal',
				zh => '期刊文献',
				ru => 'вклад в журнал',
				ca => 'contribució a revista',
				es => 'contribución a revista',
				it => 'contributo in rivista',
				pt => 'contributo em revista',
				de => 'Zeitschriftenbeitrag',
				fr => 'contribution à un journal',
			}
		},
		c_beb9 => {
			uri => 'http://purl.org/coar/resource_type/c_beb9',
			labels =>
			{
				en => 'data paper',
				zh => '数据文章',
				es => 'artículo de datos',
				fr => 'data paper',
				it => 'data paper',
				ru => 'публикация данных',
				ca => 'article de dades',
				pt => 'artigo de dados',
				de => 'Data Paper',
			}
		},
		c_ddb1 => {
			uri => 'http://purl.org/coar/resource_type/c_ddb1',
			labels =>
			{
				en => 'dataset',
				zh => '数据集',
				es => 'conjunto de datos',
				fr => 'jeu de données',
				it => 'dataset',
				ru => 'набор данных',
				de => 'Datensatz',
				ca => 'conjunt de dades',
				pt => 'conjunto de dados',
			}
		},
		c_db06 => {
			uri => 'http://purl.org/coar/resource_type/c_db06',
			labels =>
			{
				en => 'doctoral thesis',
				zh => '博士学位论文',
				es => 'tesis doctoral',
				fr => 'thèse de doctorat',
				it => 'tesi di dottorato',
				de => 'Dissertation oder Habilitation',
				ru => 'диссертация на соискание учёной степени',
				ca => 'tesi doctoral',
				pt => 'tese de doutoramento',
			}
		},
		c_c513 => {
			uri => 'http://purl.org/coar/resource_type/c_c513',
			labels =>
			{
				en => 'image',
				zh => '图像',
				es => 'imagen',
				it => 'immagine',
				ru => 'изображение ',
				de => 'Bild',
				ca => 'imatge',
				pt => 'imagem',
				fr => 'image',
			}
		},
		c_8544 => {
			uri => 'http://purl.org/coar/resource_type/c_8544',
			labels =>
			{
				en => 'lecture',
				zh => '讲座',
				es => 'ponencia',
				it => 'lezione',
				de => 'Vorlesung',
				ru => 'материалы лекций',
				ca => 'ponència',
				pt => 'palestra',
				fr => 'cours magistral',
			}
		},
		c_0857 => {
			uri => 'http://purl.org/coar/resource_type/c_0857',
			labels =>
			{
				en => 'letter',
				zh => '信',
				es => 'carta',
				ru => 'письмо',
				ca => 'carta',
				it => 'comunicazione',
				pt => 'carta',
				de => 'Brief',
				fr => 'lettre',
			}
		},
		c_bdcc => {
			uri => 'http://purl.org/coar/resource_type/c_bdcc',
			labels =>
			{
				en => 'master thesis',
				zh => '硕士学位论文',
				es => 'tesina',
				fr => 'mémoire de master',
				it => 'tesi di master',
				ru => 'диплом магистра ',
				de => 'Abschlussarbeit (Master)',
				ca => 'tesi de mestratge',
				pt => 'dissertação de mestrado',
			}
		},
		c_8a7e => {
			uri => 'http://purl.org/coar/resource_type/c_8a7e',
			labels =>
			{
				en => 'moving image',
				zh => '运动图像',
				es => 'imagen dinámica',
				fr => 'image animée',
				it => 'immagine dinamica',
				de => 'Bewegte Bilder',
				ru => 'движущееся изображение',
				ca => 'imatge en moviment',
				pt => 'imagem animada',
			}
		},
		c_545b => {
			uri => 'http://purl.org/coar/resource_type/c_545b',
			labels =>
			{
				en => 'letter to the editor',
				zh => '读者来信',
				it => 'lettera al direttore',
				ru => 'письмо редактору',
				ca => 'carta al director',
				es => 'carta al director',
				pt => 'carta ao editor',
				de => 'Leserbrief',
				fr => "lettre à l'éditeur",
			}
		},
		c_1843 => {
			uri => 'http://purl.org/coar/resource_type/c_1843',
			labels =>
			{
				en => 'other',
				zh => '其他',
				es => 'otros',
				ru => 'прочее ',
				fr => 'autre',
				it => 'altro',
				ca => 'altre',
				pt => 'outros',
				de => 'sonstige',
			}
		},
		c_15cd => {
			uri => 'http://purl.org/coar/resource_type/c_15cd',
			labels =>
			{
				en => 'patent',
				zh => '专利',
				es => 'patente',
				ru => 'патент',
				fr => 'brevet',
				it => 'brevetto',
				de => 'Patent',
				ca => 'patent',
				pt => 'patente',
			}
		},
		c_816b => {
			uri => 'http://purl.org/coar/resource_type/c_816b',
			labels =>
			{
				en => 'preprint',
				zh => '预印本',
				es => 'artículo preliminar',
				fr => 'prépublication',
				it => 'articolo preliminare',
				de => 'Preprint',
				ru => 'препринт',
				ca => 'publicació preliminar',
				pt => 'preprint',
			}
		},
		c_93fc => {
			uri => 'http://purl.org/coar/resource_type/c_93fc',
			labels =>
			{
				en => 'report',
				zh => '报告',
				es => 'informe',
				fr => 'rapport',
				it => 'rapporto',
				ru => 'отчёт',
				de => 'Verschiedenartige Texte',
				ca => 'informe',
				pt => 'relatório',
			}
		},
		c_ba1f => {
			uri => 'http://purl.org/coar/resource_type/c_ba1f',
			labels =>
			{
				en => 'report part',
				zh => '报告部分',
				es => 'parte de un estudio',
				fr => 'chapitre de rapport',
				it => 'capitolo di rapporto tecnico',
				ru => 'часть доклада ',
				ca => "part d'un informe",
				pt => 'capítulo de relatório',
				de => 'Teilbericht',
			}
		},
		c_baaf => {
			uri => 'http://purl.org/coar/resource_type/c_baaf',
			labels =>
			{
				en => 'research proposal',
				zh => '研究计划',
				es => 'propuesta de investigación',
				fr => 'projet de recherche',
				it => 'proposta di progetto',
				ru => 'предложение по исследованию',
				ca => 'proposta de recerca',
				pt => 'proposta de investigação',
				de => 'Exposé',
			}
		},
		c_5ce6 => {
			uri => 'http://purl.org/coar/resource_type/c_5ce6',
			labels =>
			{
				en => 'software',
				zh => '软件',
				es => 'software',
				fr => 'développement informatique',
				it => 'software',
				ru => 'программное обеспечение ',
				de => 'Software',
				ca => 'programari',
				pt => 'software',
			}
		},
		c_ecc8 => {
			uri => 'http://purl.org/coar/resource_type/c_ecc8',
			labels =>
			{
				en => 'still image',
				zh => '静态图像',
				es => 'imagen fija',
				ru => 'статическое изображение',
				fr => 'image fixe',
				it => 'immagine fissa',
				de => 'Einzelbild',
				ca => 'imatge fixa',
				pt => 'imagem estática',
			}
		},
		c_71bd => {
			uri => 'http://purl.org/coar/resource_type/c_71bd',
			labels =>
			{
				en => 'technical documentation',
				zh => '技术资料',
				es => 'documentación técnica',
				fr => 'manuel technique',
				it => 'documentazione tecnica',
				ru => 'техническая документация',
				de => 'Technische Dokumentation',
				ca => 'documentació tècnica',
				pt => 'documentação técnica',
			}
		},
		c_393c => {
			uri => 'http://purl.org/coar/resource_type/c_393c',
			labels =>
			{
				en => 'workflow',
				zh => '工作流程',
				es => 'flujo de trabajo',
				ru => 'рабочий процесс',
				it => 'procedura',
				de => 'Workflow',
				ca => 'flux de treball ',
				pt => 'fluxo de trabalho',
				fr => 'workflow',
			}
		},
		c_8042 => {
			uri => 'http://purl.org/coar/resource_type/c_8042',
			labels =>
			{
				en => 'working paper',
				zh => '研究手稿',
				es => 'documento de trabajo',
				fr => 'working paper',
				it => 'working paper',
				de => 'Arbeitspapier',
				ru => 'рабочий документ',
				ca => 'document de treball',
				pt => 'working paper',
			}
		},
		c_46ec => {
			uri => 'http://purl.org/coar/resource_type/c_46ec',
			labels =>
			{
				en => 'thesis',
				zh => '学位论文',
				es => 'tesis',
				fr => 'thèse',
				it => 'tesi',
				ru => 'научно-исследовательская работа',
				ca => 'tesis',
				pt => 'tese',
				de => 'schriftliche Abschlussarbeit',
			}
		},
		c_12cc => {
			uri => 'http://purl.org/coar/resource_type/c_12cc',
			labels =>
			{
				en => 'cartographic material',
				ru => 'картографические ресурсы',
				ca => 'material cartogràfic',
				es => 'material cartográfico',
				it => 'cartografia',
				zh => '地图类资料',
				pt => 'material cartográfico',
				de => 'kartographisches Material',
				fr => 'matériel cartographique',
			}
		},
		c_12cd => {
			uri => 'http://purl.org/coar/resource_type/c_12cd',
			labels =>
			{
				en => 'map',
				ru => 'карта ',
				ca => 'mapa',
				es => 'mapa',
				it => 'mappa',
				zh => '地图',
				pt => 'mapa',
				de => 'Karte',
				fr => 'carte géographique',
			}
		},
		c_12ce => {
			uri => 'http://purl.org/coar/resource_type/c_12ce',
			labels =>
			{
				en => 'video',
				ru => 'видео',
				zh => '视频',
				ca => 'vídeo',
				es => 'vídeo',
				it => 'video',
				pt => 'vídeo',
				de => 'Video',
				fr => 'vidéo',
			}
		},
		c_18cc => {
			uri => 'http://purl.org/coar/resource_type/c_18cc',
			labels =>
			{
				en => 'sound',
				ru => 'фонодокумент',
				ca => 'so',
				es => 'sonido',
				it => 'suono',
				zh => '声音',
				pt => 'som',
				de => 'Ton',
				fr => 'son',
			}
		},
		c_18cd => {
			uri => 'http://purl.org/coar/resource_type/c_18cd',
			labels =>
			{
				en => 'musical composition',
				ru => 'музыкальная композиция',
				ca => 'composició musical',
				es => 'composición musical',
				it => 'composizione musicale',
				zh => '音乐',
				pt => 'composição musical',
				de => 'musikalische Komposition',
				fr => 'composition musicale',
			}
		},
		c_18cf => {
			uri => 'http://purl.org/coar/resource_type/c_18cf',
			labels =>
			{
				en => 'text',
				ru => 'текстовый ресурс',
				ca => 'texte',
				es => 'texto',
				it => 'testo',
				zh => '文本',
				pt => 'texto',
				de => 'Text',
				fr => 'texte',
			}
		},
		c_18cp => {
			uri => 'http://purl.org/coar/resource_type/c_18cp',
			labels =>
			{
				en => 'conference paper not in proceedings',
				ru => 'неопубликованный доклад конференции',
				ca => 'comunicació no publicada en actes de congrés',
				es => 'comunicación no publicada en actas de congreso',
				it => 'comunicazione non pubblicata in atti di congresso',
				zh => '未发表在会议论文集中的文章',
				pt => 'comunicação não publicada nas atas da conferência',
				de => 'Konferenzbeitrag nicht im Tagungsband',
				fr => 'article dans une conférence non publié dans les actes',
			}
		},
		c_18co => {
			uri => 'http://purl.org/coar/resource_type/c_18co',
			labels =>
			{
				en => 'conference poster not in proceedings',
				ca => 'poster no publicat en actes de congrés',
				es => 'póster no publicado en actas de congreso',
				it => 'poster non pubblicato in atti di congresso',
				zh => '未发表在会议论文集中的海报',
				pt => 'póster não publicado nas atas da conferência',
				de => 'Konferenzposter nicht im Tagungsband',
				fr => 'poster dans une conférence non publié dans les actes',
				ru => 'неопубликованный постер конференции',
			}
		},
		c_18cw => {
			uri => 'http://purl.org/coar/resource_type/c_18cw',
			labels =>
			{
				en => 'musical notation',
				ru => 'музыкальная нотация',
				ca => 'notació musical',
				es => 'notación musical',
				it => 'notazione musicale',
				zh => '乐谱',
				pt => 'notação musical',
				de => 'Musiknotation',
				fr => 'partition',
			}
		},
		c_18ww => {
			uri => 'http://purl.org/coar/resource_type/c_18ww',
			labels =>
			{
				en => 'internal report',
				ru => 'внутренний отчёт',
				ca => 'informe intern',
				es => 'informe interno',
				it => 'rapporto interno',
				zh => '内部报告',
				de => 'interner Bericht',
				fr => 'rapport interne',
				pt => 'relatório interno',
			}
		},
		c_18wz => {
			uri => 'http://purl.org/coar/resource_type/c_18wz',
			labels =>
			{
				en => 'memorandum',
				ru => 'меморандум',
				ca => 'memoràndum',
				es => 'memorándum',
				it => 'memorandum',
				zh => '备忘录',
				pt => 'memorando',
				de => 'Memorandum',
				fr => 'mémo',
			}
		},
		c_18wq => {
			uri => 'http://purl.org/coar/resource_type/c_18wq',
			labels =>
			{
				en => 'other type of report',
				ru => 'прочие отчёты',
				ca => "altre tipus d'informe",
				es => 'otro tipo de informe',
				it => 'altro tipo di rapporto',
				zh => '其他报告',
				de => 'sonstiger Report',
				fr => 'autre type de rapport',
				pt => 'outro relatório',
			}
		},
		c_186u => {
			uri => 'http://purl.org/coar/resource_type/c_186u',
			labels =>
			{
				en => 'policy report',
				ca => 'informe polític',
				es => 'memoria de actuación',
				it => 'informativa politica',
				zh => '政策报告',
				pt => 'relatório de política',
				de => 'Bericht',
				fr => 'rapport stratégique',
				ru => 'общие положения',
			}
		},
		c_18op => {
			uri => 'http://purl.org/coar/resource_type/c_18op',
			labels =>
			{
				en => 'project deliverable',
				ru => 'результат проекта',
				ca => 'entrega de projecte',
				es => 'entregable de proyecto',
				it => 'deliverable di progetto',
				zh => '项目可交付成果',
				pt => 'entregável de projeto',
				de => 'Ergebnis im Projekt',
				fr => 'livrable',
			}
		},
		c_18hj => {
			uri => 'http://purl.org/coar/resource_type/c_18hj',
			labels =>
			{
				en => 'report to funding agency',
				ru => 'финансовый отчёт',
				ca => 'informe per una agència de finançament ',
				es => 'informe a organismo financiador',
				it => "rapporto a un'agenzia di finanziamento",
				zh => '给资助机构的报告',
				pt => 'relatório para organismo financiador',
				de => 'Bericht an Förderorganisation',
				fr => "rapport à l'intention du financeur",
			}
		},
		c_18ws => {
			uri => 'http://purl.org/coar/resource_type/c_18ws',
			labels =>
			{
				en => 'research report',
				ru => 'научно-исследовательский отчёт',
				ca => 'informe de recerca',
				it => 'rapporto di ricerca',
				zh => '研究报告',
				de => 'Forschungsbericht',
				fr => 'rapport de recherche',
				pt => 'relatório de investigação',
			}
		},
		c_18gh => {
			uri => 'http://purl.org/coar/resource_type/c_18gh',
			labels =>
			{
				en => 'technical report',
				ru => 'технический отчёт',
				ca => 'informe tècnic',
				it => 'rapporto tecnico',
				zh => '技术报告',
				pt => 'relatório técnico',
				de => 'technischer Bericht',
				fr => 'rapport technique',
			}
		}
	};
}
