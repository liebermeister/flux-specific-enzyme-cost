function names = fsc_kegg_compound_id_to_name(ids,file_kegg_compound_id_to_name)

if ~exist('file_kegg_compound_id_to_name','var'),
  file_kegg_compound_id_to_name = '/home/wolfram/projekte/data/kegg/kegg_compound_names.tsv';
end

T = load_any_table(file_kegg_compound_id_to_name);
names = repmat({''},length(ids),1);

ll = label_names(ids,T(:,1));
names(find(ll)) = T(ll(find(ll)),2);