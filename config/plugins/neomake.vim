
" Neomake
" ---------
let g:neomake_open_list = 1
let g:neomake_verbose = 1
let g:airline#extensions#neomake#enabled = 1

call neomake#configure#automake('rw')

if ! empty(g:python3_host_prog)
	let g:neomake_python_python_exe = g:python3_host_prog
endif

" JAVASCRIPT / JSX
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe = './node_modules/.bin/eslint'
let g:neomake_javascript_eslint_exe = '/usr/local/bin/eslint'

" YAML / ANSIBLE
let g:neomake_yaml_enabled_makers = ['yamllint']
let g:neomake_ansible_enabled_makers = ['yamllint']
let g:neomake_ansible_yamllint_maker = neomake#makers#ft#yaml#yamllint()

" SHELL
let g:neomake_shellcheck_args = ['-fgcc']

" JAVASCRIPT / JSX
function! s:set_javascript_exe()
	" Set buffer makers to ESLint or Flow, if executables exist.
	let g:neomake_javascript_enabled_makers = []
	for item in ['eslint', 'flow']
		let l:exe = s:find_node_executable(item)
		if ! empty(l:exe)
			call add(g:neomake_javascript_enabled_makers, item)
			let b:neomake_javascript_{item}_exe = l:exe
		endif
	endfor
	let g:neomake_jsx_enabled_makers = g:neomake_javascript_enabled_makers
endfunction

function! s:find_node_executable(cmd)
	" Find locally-installed NodeJS executable.
	" Credits: https://github.com/jaawerth/nrun.vim
	let l:cwd = expand('%:p:h')
	let l:rp = fnamemodify('/', ':p')
	let l:hp = fnamemodify('~/', ':p')
	while l:cwd != l:hp && l:cwd != l:rp
		if filereadable(resolve(l:cwd . '/package.json'))
			let l:execPath = fnamemodify(l:cwd . '/node_modules/.bin/' . a:cmd, ':p')
			if executable(l:execPath)
				return l:execPath
			endif
		endif
		let l:cwd = resolve(l:cwd . '/..')
	endwhile
	return ''
endfunction

autocmd MyAutoCmd BufWritePre *.js call s:set_javascript_exe()
call s:set_javascript_exe()

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
